locals {
  labels = merge(var.tags, {
    environment = var.environment
    cluster     = var.cluster_name
    team        = var.team
    service     = "adot-collector-ecs"
  })

  base_env = [
    { name = "AWS_REGION", value = var.aws_region },
    { name = "ENVIRONMENT", value = var.environment },
    { name = "CLUSTER", value = var.cluster_name },
    { name = "TEAM", value = var.team },
    { name = "AMP_REMOTE_WRITE_URL", value = var.remote_write_endpoint },
  ]

  config_env = var.adot_config_content != "" ? [
    { name = "AOT_CONFIG_CONTENT", value = var.adot_config_content }
  ] : []

  config_secret = var.adot_config_ssm_parameter_arn != "" ? [
    { name = "AOT_CONFIG_CONTENT", valueFrom = var.adot_config_ssm_parameter_arn }
  ] : []
}

resource "aws_cloudwatch_log_group" "adot" {
  name              = "/ecs/${var.name_prefix}/${var.environment}/adot"
  retention_in_days = var.log_retention_days

  tags = local.labels
}

data "aws_iam_policy_document" "ecs_task_assume" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_execution" {
  name               = "${var.name_prefix}-${var.environment}-${var.cluster_name}-adot-exec"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json

  tags = local.labels
}

resource "aws_iam_role_policy_attachment" "task_execution_default" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name               = "${var.name_prefix}-${var.environment}-${var.cluster_name}-adot-task"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume.json

  tags = local.labels
}

data "aws_iam_policy_document" "task" {
  statement {
    sid    = "AllowECSDiscovery"
    effect = "Allow"
    actions = [
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:ListServices",
      "ecs:DescribeServices",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeTaskDefinition",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeTags",
      "servicediscovery:ListServices",
      "servicediscovery:ListInstances",
      "servicediscovery:GetService",
      "cloudwatch:PutMetricData",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries",
    ]
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = var.amp_workspace_arn != "" ? [1] : []
    content {
      sid       = "AllowAMPRemoteWrite"
      effect    = "Allow"
      actions   = ["aps:RemoteWrite"]
      resources = [var.amp_workspace_arn]
    }
  }

  dynamic "statement" {
    for_each = var.adot_config_ssm_parameter_arn != "" ? [1] : []
    content {
      sid    = "AllowReadCollectorConfigParameter"
      effect = "Allow"
      actions = [
        "ssm:GetParameter",
        "ssm:GetParameters",
      ]
      resources = [var.adot_config_ssm_parameter_arn]
    }
  }
}

resource "aws_iam_policy" "task" {
  name        = "${var.name_prefix}-${var.environment}-${var.cluster_name}-adot-task"
  description = "Least privilege IAM policy for ADOT Collector running in ECS"
  policy      = data.aws_iam_policy_document.task.json

  tags = local.labels
}

resource "aws_iam_role_policy_attachment" "task" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.task.arn
}

resource "aws_ecs_task_definition" "adot" {
  family                   = "${var.name_prefix}-${var.environment}-adot-collector"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.task_cpu)
  memory                   = tostring(var.task_memory)
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = "adot-collector"
      image     = var.adot_image
      essential = true

      environment = concat(local.base_env, local.config_env)
      secrets     = local.config_secret

      portMappings = [
        {
          containerPort = 13133
          hostPort      = 13133
          protocol      = "tcp"
        }
      ]

      healthCheck = {
        command     = ["CMD-SHELL", "wget -qO- http://localhost:13133/ || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 30
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.adot.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = local.labels
}

resource "aws_ecs_service" "adot" {
  name            = "adot-collector"
  cluster         = var.ecs_cluster_arn
  task_definition = aws_ecs_task_definition.adot.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  enable_execute_command             = true
  health_check_grace_period_seconds  = 30

  network_configuration {
    assign_public_ip = var.assign_public_ip
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = local.labels
}

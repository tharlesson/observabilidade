locals {
  labels = merge(var.tags, {
    environment = var.environment
    cluster     = var.cluster_name
    team        = var.team
    service     = "ec2-observability"
  })

  install_script = templatefile("${path.module}/templates/install.sh.tmpl", {
    node_exporter_version = var.node_exporter_version
    otelcol_version       = var.otelcol_version
    environment           = var.environment
    cluster_name          = var.cluster_name
    team                  = var.team
    remote_write_endpoint = var.remote_write_endpoint
    aws_region            = var.aws_region
    collector_config_s3   = var.collector_config_s3_uri
  })
}

resource "aws_iam_role" "instance" {
  name = "${var.name_prefix}-${var.environment}-${var.cluster_name}-ec2-observability"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.labels
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "instance_extra" {
  statement {
    sid    = "AllowCloudWatchAndLogs"
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
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
    for_each = var.amp_workspace_arn == "" && var.remote_write_endpoint != "" ? [1] : []

    content {
      sid       = "AllowRemoteWriteForCustomBackend"
      effect    = "Allow"
      actions   = ["aps:RemoteWrite"]
      resources = ["*"]
    }
  }

  dynamic "statement" {
    for_each = var.collector_config_s3_uri != "" ? [1] : []

    content {
      sid    = "AllowReadCollectorConfigFromS3"
      effect = "Allow"
      actions = [
        "s3:GetObject",
      ]
      resources = [var.collector_config_s3_arn]
    }
  }
}

resource "aws_iam_policy" "instance_extra" {
  name        = "${var.name_prefix}-${var.environment}-${var.cluster_name}-ec2-observability"
  description = "Least privilege policy for EC2 node_exporter + OTel collector"
  policy      = data.aws_iam_policy_document.instance_extra.json

  tags = local.labels
}

resource "aws_iam_role_policy_attachment" "instance_extra" {
  role       = aws_iam_role.instance.name
  policy_arn = aws_iam_policy.instance_extra.arn
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name_prefix}-${var.environment}-${var.cluster_name}-ec2-observability"
  role = aws_iam_role.instance.name

  tags = local.labels
}

resource "aws_ssm_document" "install_observability" {
  name            = "${var.name_prefix}-${var.environment}-${var.cluster_name}-install-observability"
  document_type   = "Command"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Install node_exporter and OpenTelemetry Collector on EC2 instances"
    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "InstallAgentStack"
        inputs = {
          timeoutSeconds = "900"
          runCommand     = [local.install_script]
        }
      }
    ]
  })

  tags = local.labels
}

resource "aws_ssm_association" "install_observability" {
  name = aws_ssm_document.install_observability.name

  targets {
    key    = "tag:${var.target_tag_key}"
    values = [var.target_tag_value]
  }

  compliance_severity = "MEDIUM"
}

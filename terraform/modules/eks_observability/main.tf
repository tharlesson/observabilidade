locals {
  labels = merge(var.tags, {
    environment = var.environment
    cluster     = var.cluster_name
    team        = var.team
    service     = "observability"
  })
}

resource "kubernetes_namespace_v1" "observability" {
  metadata {
    name = var.namespace

    labels = {
      name        = var.namespace
      environment = var.environment
      team        = var.team
    }
  }
}

data "aws_iam_policy_document" "irsa_assume" {
  statement {
    sid     = "AllowIRSAAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.otel_service_account_name}"]
    }
  }
}

resource "aws_iam_role" "adot_irsa" {
  name               = "${var.name_prefix}-${var.environment}-${var.cluster_name}-adot-irsa"
  assume_role_policy = data.aws_iam_policy_document.irsa_assume.json

  tags = local.labels
}

data "aws_iam_policy_document" "adot_permissions" {
  statement {
    sid    = "AllowCloudWatchAndLogs"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "cloudwatch:PutMetricData",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "ec2:DescribeInstances",
      "ecs:ListClusters",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeContainerInstances",
      "eks:DescribeCluster",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowXRayWrite"
    effect = "Allow"
    actions = [
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
}

resource "aws_iam_policy" "adot_permissions" {
  name        = "${var.name_prefix}-${var.environment}-${var.cluster_name}-adot-irsa"
  description = "Least privilege permissions for ADOT running on EKS"
  policy      = data.aws_iam_policy_document.adot_permissions.json

  tags = local.labels
}

resource "aws_iam_role_policy_attachment" "adot_permissions" {
  role       = aws_iam_role.adot_irsa.name
  policy_arn = aws_iam_policy.adot_permissions.arn
}

resource "kubernetes_service_account_v1" "adot" {
  metadata {
    name      = var.otel_service_account_name
    namespace = kubernetes_namespace_v1.observability.metadata[0].name

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.adot_irsa.arn
    }

    labels = {
      app         = "adot-collector"
      environment = var.environment
      team        = var.team
    }
  }

  automount_service_account_token = true
}

resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  namespace        = kubernetes_namespace_v1.observability.metadata[0].name
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.kube_prometheus_stack_chart_version
  create_namespace = false
  timeout          = 1200

  values = [
    for path in var.kube_prometheus_values_files : file(path)
  ]

  set {
    name  = "commonLabels.environment"
    value = var.environment
  }

  set {
    name  = "commonLabels.cluster"
    value = var.cluster_name
  }

  set {
    name  = "commonLabels.team"
    value = var.team
  }

  depends_on = [kubernetes_namespace_v1.observability]
}

resource "helm_release" "otel_collector" {
  name             = "adot-collector"
  namespace        = kubernetes_namespace_v1.observability.metadata[0].name
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-collector"
  version          = var.otel_collector_chart_version
  create_namespace = false
  timeout          = 1200

  values = [
    for path in var.otel_collector_values_files : file(path)
  ]

  set {
    name  = "mode"
    value = "daemonset"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account_v1.adot.metadata[0].name
  }

  depends_on = [
    helm_release.kube_prometheus_stack,
    kubernetes_service_account_v1.adot,
  ]
}

resource "helm_release" "otel_operator" {
  count = var.enable_otel_operator ? 1 : 0

  name             = "opentelemetry-operator"
  namespace        = kubernetes_namespace_v1.observability.metadata[0].name
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart            = "opentelemetry-operator"
  version          = var.otel_operator_chart_version
  create_namespace = false
  timeout          = 1200

  values = [file(var.otel_operator_values_file)]

  depends_on = [helm_release.kube_prometheus_stack]
}

resource "kubernetes_network_policy_v1" "default_deny_ingress" {
  count = var.enable_network_policies ? 1 : 0

  metadata {
    name      = "default-deny-ingress"
    namespace = kubernetes_namespace_v1.observability.metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy_v1" "allow_same_namespace" {
  count = var.enable_network_policies ? 1 : 0

  metadata {
    name      = "allow-same-namespace"
    namespace = kubernetes_namespace_v1.observability.metadata[0].name
  }

  spec {
    pod_selector {}

    ingress {
      from {
        pod_selector {}
      }
    }

    policy_types = ["Ingress"]
  }
}

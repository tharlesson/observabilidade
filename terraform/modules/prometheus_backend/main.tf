terraform {
  required_version = ">= 1.8.0"
}

resource "aws_prometheus_workspace" "this" {
  count = var.backend_mode == "amp" ? 1 : 0

  alias = "${var.name_prefix}-${var.environment}"

  tags = merge(var.tags, {
    Name        = "${var.name_prefix}-${var.environment}"
    environment = var.environment
    team        = var.team
    service     = "prometheus-backend"
  })
}

data "aws_iam_policy_document" "remote_write" {
  count = var.backend_mode == "amp" ? 1 : 0

  statement {
    sid     = "AllowRemoteWrite"
    effect  = "Allow"
    actions = ["aps:RemoteWrite"]

    resources = [aws_prometheus_workspace.this[0].arn]
  }

  statement {
    sid    = "AllowAPSQueryMetadata"
    effect = "Allow"
    actions = [
      "aps:GetSeries",
      "aps:GetLabels",
      "aps:GetMetricMetadata",
      "aps:QueryMetrics",
    ]

    resources = [aws_prometheus_workspace.this[0].arn]
  }
}

resource "aws_iam_policy" "remote_write" {
  count = var.backend_mode == "amp" ? 1 : 0

  name        = "${var.name_prefix}-${var.environment}-amp-remote-write"
  description = "Least privilege policy for Prometheus and ADOT remote_write into AMP"
  policy      = data.aws_iam_policy_document.remote_write[0].json

  tags = merge(var.tags, {
    environment = var.environment
    team        = var.team
    service     = "prometheus-backend"
  })
}

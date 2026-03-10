output "workspace_id" {
  description = "AMP workspace id when backend_mode=amp"
  value       = try(aws_prometheus_workspace.this[0].workspace_id, null)
}

output "workspace_arn" {
  description = "AMP workspace ARN when backend_mode=amp"
  value       = try(aws_prometheus_workspace.this[0].arn, null)
}

output "remote_write_endpoint" {
  description = "Prometheus remote_write endpoint for AMP"
  value       = try("${aws_prometheus_workspace.this[0].prometheus_endpoint}api/v1/remote_write", null)
}

output "query_endpoint" {
  description = "AMP query endpoint"
  value       = try(aws_prometheus_workspace.this[0].prometheus_endpoint, null)
}

output "remote_write_policy_arn" {
  description = "IAM policy ARN for remote_write"
  value       = try(aws_iam_policy.remote_write[0].arn, null)
}

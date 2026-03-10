output "adot_task_role_arn" {
  description = "IAM role ARN used by ADOT task"
  value       = aws_iam_role.task.arn
}

output "adot_execution_role_arn" {
  description = "IAM role ARN used by ECS execution"
  value       = aws_iam_role.task_execution.arn
}

output "adot_service_name" {
  description = "ECS service name for ADOT collector"
  value       = aws_ecs_service.adot.name
}

output "adot_log_group" {
  description = "CloudWatch log group for ADOT"
  value       = aws_cloudwatch_log_group.adot.name
}

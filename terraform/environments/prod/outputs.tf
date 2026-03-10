output "amp_workspace_id" {
  description = "AMP workspace ID when backend_mode=amp"
  value       = module.prometheus_backend.workspace_id
}

output "remote_write_endpoint" {
  description = "Remote write endpoint used by edge collectors"
  value       = local.remote_write_endpoint
}

output "eks_adot_irsa_role_arn" {
  description = "IRSA role ARN for EKS ADOT collector"
  value       = try(module.eks_observability[0].adot_irsa_role_arn, null)
}

output "ecs_adot_task_role_arn" {
  description = "Task role ARN for ECS ADOT collector"
  value       = try(module.ecs_observability[0].adot_task_role_arn, null)
}

output "ec2_instance_profile" {
  description = "Instance profile for EC2 observability"
  value       = try(module.ec2_observability[0].instance_profile_name, null)
}

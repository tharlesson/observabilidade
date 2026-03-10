output "instance_profile_name" {
  description = "IAM instance profile name for EC2 observability"
  value       = aws_iam_instance_profile.this.name
}

output "ssm_document_name" {
  description = "SSM document name used to install observability stack"
  value       = aws_ssm_document.install_observability.name
}

output "ssm_association_id" {
  description = "SSM association ID"
  value       = aws_ssm_association.install_observability.association_id
}

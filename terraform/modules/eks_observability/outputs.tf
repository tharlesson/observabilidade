output "namespace" {
  description = "Namespace used by observability stack"
  value       = kubernetes_namespace_v1.observability.metadata[0].name
}

output "adot_irsa_role_arn" {
  description = "IRSA role ARN attached to ADOT service account"
  value       = aws_iam_role.adot_irsa.arn
}

output "adot_service_account" {
  description = "Service account used by ADOT collector"
  value       = kubernetes_service_account_v1.adot.metadata[0].name
}

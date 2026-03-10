variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "observability"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "environment" {
  description = "Environment label"
  type        = string
}

variable "namespace" {
  description = "Namespace for observability components"
  type        = string
  default     = "observability"
}

variable "team" {
  description = "Team owner label"
  type        = string
  default     = "platform"
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN for IRSA"
  type        = string
}

variable "oidc_provider_url" {
  description = "EKS OIDC provider URL for IRSA"
  type        = string
}

variable "amp_workspace_arn" {
  description = "AMP workspace ARN used by remote_write"
  type        = string
  default     = ""
}

variable "otel_service_account_name" {
  description = "Service account name used by ADOT collector"
  type        = string
  default     = "adot-collector"
}

variable "kube_prometheus_stack_chart_version" {
  description = "Pinned version of kube-prometheus-stack chart"
  type        = string
  default     = "68.2.1"
}

variable "otel_collector_chart_version" {
  description = "Pinned version of opentelemetry-collector chart"
  type        = string
  default     = "0.93.0"
}

variable "otel_operator_chart_version" {
  description = "Pinned version of opentelemetry-operator chart"
  type        = string
  default     = "0.83.0"
}

variable "kube_prometheus_values_files" {
  description = "Values files for kube-prometheus-stack"
  type        = list(string)
}

variable "otel_collector_values_files" {
  description = "Values files for otel collector"
  type        = list(string)
}

variable "otel_operator_values_file" {
  description = "Values file for otel operator"
  type        = string
}

variable "enable_otel_operator" {
  description = "Enable OpenTelemetry Operator chart"
  type        = bool
  default     = true
}

variable "enable_network_policies" {
  description = "Apply basic network policies in observability namespace"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "name_prefix" {
  description = "Global resource prefix"
  type        = string
  default     = "observability"
}

variable "team" {
  description = "Team owner label"
  type        = string
  default     = "platform"
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "backend_mode" {
  description = "Central metrics backend: amp or oss"
  type        = string
  default     = "amp"

  validation {
    condition     = contains(["amp", "oss"], var.backend_mode)
    error_message = "backend_mode must be amp or oss."
  }
}

variable "remote_write_endpoint_override" {
  description = "Optional remote_write endpoint when backend_mode=oss"
  type        = string
  default     = ""
}

variable "enable_eks_observability" {
  description = "Enable EKS observability module"
  type        = bool
  default     = true
}

variable "enable_ecs_observability" {
  description = "Enable ECS observability module"
  type        = bool
  default     = true
}

variable "enable_ec2_observability" {
  description = "Enable EC2 observability module"
  type        = bool
  default     = true
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig for EKS management"
  type        = string
  default     = "~/.kube/config"
}

variable "kubeconfig_context" {
  description = "Optional kubeconfig context"
  type        = string
  default     = ""
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "observability-eks"
}

variable "eks_observability_namespace" {
  description = "Namespace where observability stack will run"
  type        = string
  default     = "observability"
}

variable "eks_oidc_provider_arn" {
  description = "OIDC provider ARN for EKS IRSA"
  type        = string
  default     = ""
}

variable "eks_oidc_provider_url" {
  description = "OIDC provider URL for EKS IRSA"
  type        = string
  default     = ""
}

variable "enable_otel_operator" {
  description = "Enable OpenTelemetry Operator"
  type        = bool
  default     = true
}

variable "enable_network_policies" {
  description = "Enable baseline network policies for observability namespace"
  type        = bool
  default     = true
}

variable "kube_prometheus_stack_chart_version" {
  description = "Pinned kube-prometheus-stack chart version"
  type        = string
  default     = "68.2.1"
}

variable "otel_collector_chart_version" {
  description = "Pinned opentelemetry-collector chart version"
  type        = string
  default     = "0.93.0"
}

variable "otel_operator_chart_version" {
  description = "Pinned opentelemetry-operator chart version"
  type        = string
  default     = "0.83.0"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name label"
  type        = string
  default     = "observability-ecs"
}

variable "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
  default     = ""
}

variable "ecs_subnet_ids" {
  description = "Subnets for ADOT ECS service"
  type        = list(string)
  default     = []
}

variable "ecs_security_group_ids" {
  description = "Security groups for ADOT ECS service"
  type        = list(string)
  default     = []
}

variable "ecs_assign_public_ip" {
  description = "Assign public IP to ADOT ECS tasks"
  type        = bool
  default     = false
}

variable "ecs_adot_desired_count" {
  description = "Number of ADOT tasks"
  type        = number
  default     = 1
}

variable "ecs_adot_task_cpu" {
  description = "CPU units for ADOT task"
  type        = number
  default     = 512
}

variable "ecs_adot_task_memory" {
  description = "Memory MiB for ADOT task"
  type        = number
  default     = 1024
}

variable "ecs_adot_image" {
  description = "Pinned ADOT image for ECS"
  type        = string
  default     = "public.ecr.aws/aws-observability/aws-otel-collector:v0.43.0"
}

variable "ecs_adot_config_content" {
  description = "Inline collector config; avoid in production when possible"
  type        = string
  default     = ""
}

variable "ecs_adot_config_ssm_parameter_arn" {
  description = "SSM parameter ARN containing collector config"
  type        = string
  default     = ""
}

variable "ecs_log_retention_days" {
  description = "CloudWatch log retention"
  type        = number
  default     = 30
}

variable "ec2_cluster_label" {
  description = "Cluster label for EC2 metrics"
  type        = string
  default     = "ec2-fleet"
}

variable "ec2_target_tag_key" {
  description = "Tag key used by SSM Association"
  type        = string
  default     = "observability"
}

variable "ec2_target_tag_value" {
  description = "Tag value used by SSM Association"
  type        = string
  default     = "enabled"
}

variable "node_exporter_version" {
  description = "Pinned node_exporter version for EC2"
  type        = string
  default     = "1.8.2"
}

variable "ec2_otelcol_version" {
  description = "Pinned OpenTelemetry Collector Contrib version"
  type        = string
  default     = "0.116.1"
}

variable "ec2_collector_config_s3_uri" {
  description = "Optional S3 URI containing collector config"
  type        = string
  default     = ""
}

variable "ec2_collector_config_s3_arn" {
  description = "Optional S3 ARN for collector config object"
  type        = string
  default     = ""
}

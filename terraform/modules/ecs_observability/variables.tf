variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "observability"
}

variable "environment" {
  description = "Environment label"
  type        = string
}

variable "team" {
  description = "Team owner label"
  type        = string
  default     = "platform"
}

variable "cluster_name" {
  description = "Logical ECS cluster name used for labels"
  type        = string
}

variable "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ECS service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for ECS service"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to ADOT tasks"
  type        = bool
  default     = false
}

variable "desired_count" {
  description = "Desired number of ADOT tasks"
  type        = number
  default     = 1
}

variable "task_cpu" {
  description = "Fargate CPU units"
  type        = number
  default     = 512
}

variable "task_memory" {
  description = "Fargate memory in MiB"
  type        = number
  default     = 1024
}

variable "adot_image" {
  description = "Pinned ADOT collector image"
  type        = string
  default     = "public.ecr.aws/aws-observability/aws-otel-collector:v0.43.0"
}

variable "adot_config_content" {
  description = "Inline ADOT collector config content. Prefer using SSM parameter in production."
  type        = string
  default     = ""
}

variable "adot_config_ssm_parameter_arn" {
  description = "Optional SSM parameter ARN with collector config"
  type        = string
  default     = ""
}

variable "remote_write_endpoint" {
  description = "Prometheus remote_write endpoint used by collector"
  type        = string
  default     = ""
}

variable "amp_workspace_arn" {
  description = "AMP workspace ARN for IAM scoping"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "CloudWatch log retention for ADOT logs"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Extra tags"
  type        = map(string)
  default     = {}
}

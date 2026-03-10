variable "name_prefix" {
  description = "Prefix for all resource names"
  type        = string
  default     = "observability"
}

variable "environment" {
  description = "Environment label"
  type        = string
}

variable "cluster_name" {
  description = "Logical cluster or domain label"
  type        = string
  default     = "ec2"
}

variable "team" {
  description = "Team owner label"
  type        = string
  default     = "platform"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "remote_write_endpoint" {
  description = "Prometheus remote_write endpoint"
  type        = string
  default     = ""
}

variable "amp_workspace_arn" {
  description = "Optional AMP workspace ARN to scope aps:RemoteWrite permissions"
  type        = string
  default     = ""
}

variable "target_tag_key" {
  description = "EC2 tag key used to target association"
  type        = string
  default     = "observability"
}

variable "target_tag_value" {
  description = "EC2 tag value used to target association"
  type        = string
  default     = "enabled"
}

variable "node_exporter_version" {
  description = "Pinned node_exporter version"
  type        = string
  default     = "1.8.2"
}

variable "otelcol_version" {
  description = "Pinned opentelemetry collector contrib version"
  type        = string
  default     = "0.116.1"
}

variable "collector_config_s3_uri" {
  description = "Optional S3 URI for collector config (s3://bucket/key)"
  type        = string
  default     = ""
}

variable "collector_config_s3_arn" {
  description = "Optional S3 object ARN for collector config IAM scope"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Extra tags"
  type        = map(string)
  default     = {}
}

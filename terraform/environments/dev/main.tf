locals {
  repo_root = abspath("${path.root}/../../..")

  tags = merge(var.tags, {
    environment = var.environment
    team        = var.team
    managed-by  = "terraform"
    project     = "aws-observability"
  })

  remote_write_endpoint = var.remote_write_endpoint_override != "" ? var.remote_write_endpoint_override : try(module.prometheus_backend.remote_write_endpoint, "")
  amp_workspace_arn     = try(module.prometheus_backend.workspace_arn, "")
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.tags
  }
}

provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kubeconfig_context
  }
}

provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}

module "prometheus_backend" {
  source = "../../modules/prometheus_backend"

  backend_mode = var.backend_mode
  environment  = var.environment
  name_prefix  = var.name_prefix
  team         = var.team
  tags         = local.tags
}

module "eks_observability" {
  count  = var.enable_eks_observability ? 1 : 0
  source = "../../modules/eks_observability"

  providers = {
    aws        = aws
    helm       = helm
    kubernetes = kubernetes
  }

  name_prefix                         = var.name_prefix
  cluster_name                        = var.eks_cluster_name
  environment                         = var.environment
  team                                = var.team
  namespace                           = var.eks_observability_namespace
  oidc_provider_arn                   = var.eks_oidc_provider_arn
  oidc_provider_url                   = var.eks_oidc_provider_url
  amp_workspace_arn                   = local.amp_workspace_arn
  enable_otel_operator                = var.enable_otel_operator
  enable_network_policies             = var.enable_network_policies
  kube_prometheus_stack_chart_version = var.kube_prometheus_stack_chart_version
  otel_collector_chart_version        = var.otel_collector_chart_version
  otel_operator_chart_version         = var.otel_operator_chart_version

  kube_prometheus_values_files = [
    "${local.repo_root}/helm/kube-prometheus-stack/values/base.yaml",
    "${local.repo_root}/helm/kube-prometheus-stack/values/${var.environment}.yaml",
  ]

  otel_collector_values_files = [
    "${local.repo_root}/helm/otel-collector/values/base.yaml",
    "${local.repo_root}/helm/otel-collector/values/${var.environment}.yaml",
  ]

  otel_operator_values_file = "${local.repo_root}/helm/otel-operator/values.yaml"
  tags                      = local.tags
}

module "ecs_observability" {
  count  = var.enable_ecs_observability ? 1 : 0
  source = "../../modules/ecs_observability"

  name_prefix                   = var.name_prefix
  environment                   = var.environment
  team                          = var.team
  cluster_name                  = var.ecs_cluster_name
  ecs_cluster_arn               = var.ecs_cluster_arn
  aws_region                    = var.aws_region
  subnet_ids                    = var.ecs_subnet_ids
  security_group_ids            = var.ecs_security_group_ids
  assign_public_ip              = var.ecs_assign_public_ip
  desired_count                 = var.ecs_adot_desired_count
  task_cpu                      = var.ecs_adot_task_cpu
  task_memory                   = var.ecs_adot_task_memory
  adot_image                    = var.ecs_adot_image
  adot_config_content           = var.ecs_adot_config_content
  adot_config_ssm_parameter_arn = var.ecs_adot_config_ssm_parameter_arn
  remote_write_endpoint         = local.remote_write_endpoint
  amp_workspace_arn             = local.amp_workspace_arn
  log_retention_days            = var.ecs_log_retention_days
  tags                          = local.tags
}

module "ec2_observability" {
  count  = var.enable_ec2_observability ? 1 : 0
  source = "../../modules/ec2_observability"

  name_prefix             = var.name_prefix
  environment             = var.environment
  cluster_name            = var.ec2_cluster_label
  team                    = var.team
  aws_region              = var.aws_region
  remote_write_endpoint   = local.remote_write_endpoint
  amp_workspace_arn       = local.amp_workspace_arn
  target_tag_key          = var.ec2_target_tag_key
  target_tag_value        = var.ec2_target_tag_value
  node_exporter_version   = var.node_exporter_version
  otelcol_version         = var.ec2_otelcol_version
  collector_config_s3_uri = var.ec2_collector_config_s3_uri
  collector_config_s3_arn = var.ec2_collector_config_s3_arn
  tags                    = local.tags
}

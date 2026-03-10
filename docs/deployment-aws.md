# AWS Deployment

## Prerequisites

- Terraform >= 1.8
- AWS credentials with permissions for IAM, AMP, ECS, EKS, SSM
- Helm >= 3.15
- kubectl configured for target EKS cluster

## 1) Prepare Environment Files

For each environment (`dev`, `stage`, `prod`):

1. Enter `terraform/environments/<env>`.
2. Copy `terraform.tfvars.example` to `terraform.tfvars`.
3. Copy `backend.hcl.example` to `backend.hcl`.
4. Fill values for:
   - EKS OIDC ARN/URL
   - ECS cluster ARN/subnets/SGs
   - AMP or custom remote_write endpoint

## 2) Deploy

```bash
make deploy ENV=dev
```

Repeat for `stage` and `prod`.

## 3) What Terraform Applies

- Optional AMP workspace (`backend_mode = amp`)
- IRSA role and policy for EKS ADOT collector
- Helm releases:
  - kube-prometheus-stack
  - opentelemetry-collector
  - opentelemetry-operator (optional)
- ECS ADOT service with task role
- EC2 observability setup via SSM document/association

## 3.1) ECS ADOT config via SSM Parameter (recommended)

Use `otel/collector-ecs.yaml` as base and store in Parameter Store:

```bash
aws ssm put-parameter \
  --name /observability/adot/collector-ecs \
  --type String \
  --overwrite \
  --value \"$(cat otel/collector-ecs.yaml)\"
```

Then set `ecs_adot_config_ssm_parameter_arn` in `terraform.tfvars`.

## 4) Post-Deploy Validation

- Verify Prometheus targets are up.
- Validate remote_write success (`prometheus_remote_storage_*`).
- Confirm alert pipeline by firing test alert.
- Verify dashboards populate by environment and cluster.

## 5) Rollback

- Helm: `helm rollback` per release.
- Terraform: revert commit + `terraform apply`.
- Infra teardown: `make destroy ENV=<env>`.

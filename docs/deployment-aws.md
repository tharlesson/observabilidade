# Deploy na AWS

## Pre-requisitos

- Terraform >= 1.8
- Credenciais AWS com permissoes para IAM, AMP, ECS, EKS e SSM
- Helm >= 3.15
- `kubectl` configurado para o cluster EKS de destino

## 1) Preparar arquivos de ambiente

Para cada ambiente (`dev`, `stage`, `prod`):

1. Entre em `terraform/environments/<env>`.
2. Copie `terraform.tfvars.example` para `terraform.tfvars`.
3. Copie `backend.hcl.example` para `backend.hcl`.
4. Preencha os valores de:
   - ARN/URL do OIDC do EKS
   - ARN do cluster ECS, subnets e security groups
   - endpoint AMP ou endpoint customizado de remote_write

## 2) Deploy

```bash
make deploy ENV=dev
```

Repita para `stage` e `prod`.

## 3) O que o Terraform aplica

- Workspace AMP opcional (`backend_mode = amp`)
- Role e policy de IRSA para collector ADOT no EKS
- Releases Helm:
  - kube-prometheus-stack
  - opentelemetry-collector
  - opentelemetry-operator (opcional)
- Servico ADOT no ECS com task role
- Setup de observabilidade no EC2 via documento/associacao SSM

## 3.1) Config do ADOT no ECS via SSM Parameter (recomendado)

Use `otel/collector-ecs.yaml` como base e armazene no Parameter Store:

```bash
aws ssm put-parameter \
  --name /observability/adot/collector-ecs \
  --type String \
  --overwrite \
  --value "$(cat otel/collector-ecs.yaml)"
```

Depois configure `ecs_adot_config_ssm_parameter_arn` no `terraform.tfvars`.

## 4) Validacao pos-deploy

- Verifique se os targets do Prometheus estao no ar.
- Valide sucesso do remote_write (`prometheus_remote_storage_*`).
- Confirme o pipeline de alertas disparando um alerta de teste.
- Verifique dashboards populando por ambiente e cluster.

## 5) Reversao

- Helm: `helm rollback` por release.
- Terraform: reverter commit + `terraform apply`.
- Destruir infraestrutura: `make destroy ENV=<env>`.


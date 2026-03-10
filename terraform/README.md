# Terraform Layout

- `modules/`: módulos reutilizáveis para backend, EKS, ECS e EC2 observability.
- `environments/dev|stage|prod`: composição por ambiente com variáveis e backend remoto.

## Módulos

- `prometheus_backend`: AMP opcional + policy de remote_write
- `eks_observability`: IRSA + Helm releases (`kube-prometheus-stack`, OTel Collector, OTel Operator)
- `ecs_observability`: ADOT Collector no ECS com Task Role
- `ec2_observability`: bootstrap de node_exporter + OTel collector via SSM

## Fluxo

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
cp backend.hcl.example backend.hcl
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

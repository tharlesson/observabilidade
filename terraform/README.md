# Estrutura Terraform

- `modules/`: modulos reutilizaveis para backend, EKS, ECS e observabilidade em EC2.
- `environments/dev|stage|prod`: composicao por ambiente com variaveis e backend remoto.

## Modulos

- `prometheus_backend`: AMP opcional + policy de remote_write
- `eks_observability`: IRSA + releases Helm (`kube-prometheus-stack`, OTel Collector e OTel Operator)
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

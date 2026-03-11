# Componente: Terraform + Helm

## Finalidade

- Provisionar recursos de nuvem e IAM.
- Publicar a stack de observabilidade no Kubernetes via Helm.
- Manter `dev`, `stage` e `prod` isolados e reproduziveis.

## Arquivos de configuracao

- `terraform/modules/*`
- `terraform/environments/*`
- `helm/kube-prometheus-stack/values/*`
- `helm/otel-collector/values/*`
- `helm/otel-operator/values.yaml`

# Component: Terraform + Helm

## Purpose

- Provision cloud resources and IAM.
- Deploy Kubernetes observability stack via Helm.
- Keep `dev`, `stage`, `prod` isolated and reproducible.

## Config Files

- `terraform/modules/*`
- `terraform/environments/*`
- `helm/kube-prometheus-stack/values/*`
- `helm/otel-collector/values/*`
- `helm/otel-operator/values.yaml`

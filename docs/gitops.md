# Fluxo GitOps

## Branching

- Mantenha overlays de ambiente em `terraform/environments/*`.
- Promova por pull request de `dev` para `stage` e depois para `prod`.

## Gates de validacao

1. `make lint`
2. `make validate`
3. Revisao de Terraform plan por ambiente
4. Revisao de diff de values Helm no EKS
5. Revisao de diff de provisioning de dashboards/alertas

## Etapas sugeridas de pipeline

1. Checks estaticos
2. Terraform plan (nao-prod)
3. Terraform apply (nao-prod)
4. Smoke tests e verificacoes sinteticas
5. Aprovacao manual
6. Terraform apply (prod)

## Estrategia de reversao

- Reverter commit no Git e reaplicar.
- Para reversao urgente de dashboard/alerta, restaurar o ultimo commit valido de JSON/YAML.


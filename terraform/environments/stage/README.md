# Ambiente stage

1. Copie `terraform.tfvars.example` para `terraform.tfvars`.
2. Copie `backend.hcl.example` para `backend.hcl` e preencha os valores.
3. Execute:

```bash
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

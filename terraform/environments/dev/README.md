# dev environment

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Copy `backend.hcl.example` to `backend.hcl` and fill values.
3. Run:

```bash
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

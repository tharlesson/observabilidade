# GitOps Workflow

## Branching

- Keep environment overlays under `terraform/environments/*`.
- Promote by pull request from `dev` to `stage` to `prod`.

## Validation Gates

1. `make lint`
2. `make validate`
3. Terraform plan review for each environment
4. Helm values diff for EKS releases
5. Dashboard/alert provisioning diff review

## Suggested Pipeline Stages

1. Static checks
2. Terraform plan (non-prod)
3. Terraform apply (non-prod)
4. Smoke tests and synthetic checks
5. Manual approval
6. Terraform apply (prod)

## Rollback Strategy

- Revert Git commit and re-apply.
- For urgent dashboard/alert rollback, restore last known good JSON/YAML commit.

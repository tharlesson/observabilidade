# Security Baseline

## Identity and Access

- IRSA on EKS for ADOT collector.
- ECS task role for ADOT collector.
- EC2 instance profile for node_exporter/collector bootstrap.
- AMP write permissions scoped to workspace ARN whenever possible.

## Secrets

- No secrets stored in repository.
- Use `.env` for local lab only.
- Prefer AWS SSM Parameter Store or Secrets Manager for production.

## Network Controls

- Kubernetes NetworkPolicy baseline in observability namespace.
- Security groups for ECS collectors restricted to required egress.
- Blackbox endpoints should be allowlisted explicitly.

## Transport Security

- TLS examples for Prometheus, Grafana, Alertmanager in local lab.
- Use managed certificates/ingress TLS termination in AWS production.

## Hardening TODOs for Production

- Replace self-signed certs with ACM/public or private CA certs.
- Use WAF + private ingress for Grafana/Alertmanager.
- Enforce SSO/OIDC in Grafana.
- Add image signing verification and admission policies.

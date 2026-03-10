# Validation Checklist

## Infrastructure

- [ ] Terraform apply succeeds for target environment.
- [ ] AMP workspace exists (if backend_mode=amp).
- [ ] IRSA role bound to EKS collector service account.
- [ ] ECS ADOT service running desired task count.
- [ ] SSM association applied to EC2 instances with target tag.

## Data Collection

- [ ] node_exporter targets are `UP`.
- [ ] kube-state-metrics targets are `UP`.
- [ ] blackbox probes produce `probe_success`.
- [ ] OTLP telemetry reaches collector.
- [ ] Prometheus remote_write queue has no sustained failures.

## Dashboards

- [ ] EC2 dashboard shows host CPU/memory/disk/network.
- [ ] ECS dashboard shows desired/running tasks and resource usage.
- [ ] EKS dashboard shows node/pod/deployment health.
- [ ] Blackbox dashboard shows availability and cert expiry.
- [ ] Self-monitoring dashboard shows core stack health.

## Alerts

- [ ] Critical/warning/info routing works.
- [ ] Inhibit rules suppress child noise correctly.
- [ ] Grouping reduces duplicate notifications.
- [ ] Silence creation tested via API/UI.

## Security

- [ ] No plaintext secrets committed.
- [ ] TLS certificates valid for all exposed endpoints.
- [ ] Basic auth/SSO enabled for admin surfaces.
- [ ] IAM policies are least privilege and scoped.

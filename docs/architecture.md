# Architecture

## Goals

- One reusable observability platform for EC2, ECS and EKS.
- Everything as code (Terraform, Helm, YAML provisioning).
- Environment isolation for `dev`, `stage`, `prod`.
- Centralized dashboards and alerts with standardized labels.

## Logical Architecture

1. Edge collectors:
   - `node_exporter` on EC2/VMs.
   - ADOT Collector on ECS (service/sidecar, with `ecs_observer`).
   - ADOT/OpenTelemetry Collector on EKS (daemonset).
2. Scrape and aggregate:
   - Prometheus Agent or Prometheus server in edge clusters.
   - Optional central Prometheus-compatible backend (AMP).
3. Control plane:
   - Grafana OSS central with file provisioning.
   - Alertmanager OSS central with routing/inhibit/grouping/templates.
4. Health checks:
   - `blackbox_exporter` for HTTP/HTTPS/TCP/certificate expiry.

## Why This Layout

- Keeps data collection close to workloads for resilience and reduced egress.
- Supports hybrid operation:
  - Local/lab with OSS components in Docker Compose.
  - AWS production with AMP remote_write and IAM-scoped credentials.
- Separates responsibilities:
  - Terraform: infrastructure, IAM, IRSA, ECS task roles.
  - Helm: Kubernetes runtime configs.
  - Prometheus/Grafana/Alertmanager YAML/JSON: operational behavior.

## Security Model

- IAM least privilege:
  - IRSA role for EKS collector.
  - Task role for ECS collector.
  - EC2 instance profile for SSM + metrics shipping.
- No hardcoded secrets:
  - `.env.example`, SSM parameter placeholders and webhook placeholders.
- TLS and auth in local lab examples for Prometheus/Grafana/Alertmanager.
- Network policies in observability namespace (baseline deny ingress + allow namespace).

## Label Standard

All metrics/alerts must carry:

- `environment`
- `cluster`
- `service`
- `namespace`
- `team`
- `severity` (alerts)

This repository enforces labels by:
- Collector resource processors.
- Prometheus external labels and relabeling.
- Alert rule labels.
- Dashboard variable filters.

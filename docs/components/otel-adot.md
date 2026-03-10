# Component: OpenTelemetry / ADOT

## Purpose

- Collect OTLP, host and platform metrics.
- Enrich telemetry with resource labels.
- Export to Prometheus-compatible backend.

## Config Files

- `otel/collector-ec2.yaml`
- `otel/collector-ecs.yaml`
- `otel/collector-eks.yaml`
- `helm/otel-collector/values/*.yaml`
- `helm/otel-operator/values.yaml`

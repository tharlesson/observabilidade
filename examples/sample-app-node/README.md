# Sample App Node

- Exposes `/metrics` in Prometheus format.
- Exports traces/metrics to OTLP via gRPC.

## Run locally

```bash
npm install
npm start
```

Environment variables:
- `OTEL_EXPORTER_OTLP_ENDPOINT`
- `OTEL_SERVICE_NAME`
- `ENVIRONMENT`
- `CLUSTER`
- `TEAM`

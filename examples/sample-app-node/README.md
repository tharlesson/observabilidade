# App de exemplo em Node

- Expoe `/metrics` no formato Prometheus.
- Exporta traces/metricas para OTLP via gRPC.

## Executar localmente

```bash
npm install
npm start
```

Variaveis de ambiente:
- `OTEL_EXPORTER_OTLP_ENDPOINT`
- `OTEL_SERVICE_NAME`
- `ENVIRONMENT`
- `CLUSTER`
- `TEAM`

# Componente: OpenTelemetry / ADOT

## Finalidade

- Coletar OTLP, metricas de host e metricas de plataforma.
- Enriquecer telemetria com labels de recurso.
- Exportar para backend compativel com Prometheus.

## Arquivos de configuracao

- `otel/collector-ec2.yaml`
- `otel/collector-ecs.yaml`
- `otel/collector-eks.yaml`
- `helm/otel-collector/values/*.yaml`
- `helm/otel-operator/values.yaml`

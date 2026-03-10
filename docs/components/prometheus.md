# Componente: Prometheus

## Finalidade

- Fazer scrape de metricas de exporters/aplicacoes.
- Avaliar recording rules e alertas.
- Encaminhar alertas para o Alertmanager.
- Fazer remote_write opcional para AMP.

## Arquivos de configuracao

- `prometheus/prometheus.yml`
- `prometheus/rules/*.yaml`
- `prometheus/recording-rules/*.yaml`
- `prometheus/scrape-configs/*.yaml`
- `prometheus/web.yml`

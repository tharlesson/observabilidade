# Componente: Exportadores

## Finalidade

- `node_exporter`: metricas de host em EC2/VMs.
- `kube-state-metrics`: metricas de estado dos objetos Kubernetes.
- `blackbox_exporter`: probing sintetico (HTTP/HTTPS/TCP/TLS).

## Arquivos de configuracao

- `exporters/blackbox/blackbox.yml`
- `prometheus/scrape-configs/blackbox-scrape.yaml`


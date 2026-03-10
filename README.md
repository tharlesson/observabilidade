# Plataforma de Observabilidade AWS (IaC Pronta para Producao)

Plataforma de observabilidade como codigo para AWS, com suporte a:

- VMs/EC2
- workloads no ECS
- clusters EKS
- aplicacoes instrumentadas com OpenTelemetry e `/metrics`

Componentes obrigatorios incluidos neste repositorio:

- Prometheus
- Grafana OSS
- Alertmanager OSS
- OpenTelemetry Collector
- AWS Distro for OpenTelemetry (ADOT)
- node_exporter
- kube-state-metrics
- blackbox_exporter
- Prometheus Operator / kube-prometheus-stack
- Terraform
- Helm
- Docker Compose para laboratorio local

## 1) Caracteristicas principais

- Observabilidade multiambiente (`dev`, `stage`, `prod`)
- Provisionamento versionado com Terraform + Helm
- Grafana com provisioning declarativo (datasources, dashboards e alerting)
- Alertmanager com rotas por severidade (`critical`, `warning`, `info`)
- Inhibit rules, grouping e modelo de silences
- Recording rules para consultas pesadas
- Guias de resposta para os alertas principais
- Suporte a backend central compativel com Prometheus (AMP opcional)
- Laboratorio local com Docker Compose (TLS + auth + persistencia)

## 2) Versoes pinadas

| Componente | Versao pinada |
|---|---|
| Terraform | >= 1.8.0 |
| AWS Provider | ~> 5.45 |
| Helm Provider | ~> 2.13 |
| Kubernetes Provider | ~> 2.30 |
| Prometheus | v2.54.1 |
| Alertmanager | v0.28.0 |
| Grafana OSS | 11.2.2 |
| node_exporter | v1.8.2 |
| blackbox_exporter | v0.25.0 |
| ADOT Collector image | v0.43.0 |
| OTel Collector chart | 0.93.0 |
| OTel Operator chart | 0.83.0 |
| kube-prometheus-stack chart | 68.2.1 |

## 3) Estrutura do repositorio

```text
terraform/
  environments/
    dev/
    stage/
    prod/
  modules/
    prometheus_backend/
    eks_observability/
    ecs_observability/
    ec2_observability/

helm/
  kube-prometheus-stack/values/
  otel-collector/values/
  otel-operator/

grafana/
  provisioning/
    datasources/
    dashboards/
    alerting/
  dashboards-json/

prometheus/
  rules/
  recording-rules/
  scrape-configs/
  prometheus.yml
  web.yml

alertmanager/
  alertmanager.yml
  web.yml
  templates/

otel/
  collector-ec2.yaml
  collector-ecs.yaml
  collector-eks.yaml

exporters/
  blackbox/blackbox.yml

docker-compose/
  local-lab/
    docker-compose.yml

examples/
  sample-app-node/
  sample-app-java/
  sample-app-python/

scripts/
docs/
Makefile
README.md
```

## 4) Arquitetura e decisoes

Detalhes completos: [`docs/architecture.md`](docs/architecture.md)

Decisoes principais:

1. Coleta na borda com ADOT/OTel + exporters para reduzir acoplamento.
2. Backend central compativel com Prometheus via `remote_write`.
3. Dashboards e alertas centralizados em Grafana OSS e Alertmanager OSS.
4. Infra e runtime declarativos (Terraform + Helm + YAML/JSON provisioning).
5. Labels padrao aplicadas em metricas/alertas para governanca e roteamento.

## 5) Labels padrao

Todas as metricas e alertas devem usar:

- `environment`
- `cluster`
- `service`
- `namespace`
- `team`
- `severity` (alertas)

Essas labels sao reforcadas em:

- Configuracoes de collector (`resource` processor)
- External labels e relabeling no Prometheus
- Rule labels no Prometheus/Grafana

## 6) Monitoramento por dominio

### EC2 / VMs

Inclui:

- bootstrap de `node_exporter` via SSM
- dashboards de CPU, memoria, disco, inode, load e rede
- alertas de indisponibilidade, CPU alta, memoria alta, disco enchendo e inode baixo

### ECS

Inclui:

- ADOT Collector como servico ECS
- Task Role com least privilege
- `ecs_observer` para descoberta automatica de tasks
- coleta OTLP + Prometheus `/metrics`
- alertas de degradacao de servico e mismatch de tasks

### EKS

Inclui:

- `kube-prometheus-stack` (Prometheus Operator)
- `kube-state-metrics` e `node_exporter`
- ADOT/OTel Collector
- OpenTelemetry Operator opcional
- IRSA para collector
- ServiceMonitor/PodMonitor de exemplo
- alertas de saude de Node/Pod/Replica

### Aplicacoes

Exemplos reais prontos:

- Node.js: `/metrics` + OTLP
- Java (Spring Boot): `/actuator/prometheus` + OTEL Java Agent
- Python (Flask): `/metrics` + OTLP

No laboratorio local, os exemplos sobem com profile `examples` em:

- `http://localhost:8081` (Node)
- `http://localhost:8082` (Python)
- `http://localhost:8083` (Java)

## 7) Dashboards e alerting

### Provisioning do Grafana

- Datasources: `grafana/provisioning/datasources/datasources.yaml`
- Dashboards provider: `grafana/provisioning/dashboards/dashboards.yaml`
- Alerting provisioning:
  - `grafana/provisioning/alerting/contact-points.yaml`
  - `grafana/provisioning/alerting/notification-policies.yaml`
  - `grafana/provisioning/alerting/alert-rules.yaml`
  - `grafana/provisioning/alerting/mute-timings.yaml`

### Dashboards JSON prontos

- `ec2-overview.json`
- `ecs-overview.json`
- `eks-overview.json`
- `blackbox-overview.json`
- `self-monitoring.json`

### Roteamento no Alertmanager

- `critical` -> Slack + Email + Teams webhook
- `warning` -> Slack + Email
- `info` -> Teams/Slack de informacao
- grouping, inhibit rules e mute intervals configurados

## 8) Laboratorio local (Docker Compose)

Guia completo: [`docs/local-lab.md`](docs/local-lab.md)

Passos rapidos:

```bash
cp .env.example .env
make bootstrap-local
make up-local
```

Endpoints:

- Grafana: `https://localhost:3000`
- Prometheus: `https://localhost:9090`
- Alertmanager: `https://localhost:9093`

Credenciais padrao do laboratorio:

- Grafana: `admin / change-me`
- Prometheus: `prom_admin / prom-admin-change-me`
- Alertmanager: `alert_admin / alert-admin-change-me`

Para parar o laboratorio:

```bash
make down-local
```

## 9) Deploy na AWS

Guia completo: [`docs/deployment-aws.md`](docs/deployment-aws.md)

Fluxo por ambiente:

1. Configurar `terraform.tfvars` e `backend.hcl`
2. Executar `make deploy ENV=dev`
3. Promover para `stage` e `prod`

## 10) Seguranca

Guia completo: [`docs/security.md`](docs/security.md)

Inclui baseline de:

- IAM least privilege
- IRSA (EKS) e Task Role (ECS)
- TLS + auth em superficies sensiveis
- placeholders para secrets
- NetworkPolicy no namespace de observabilidade

## 11) Comandos uteis

```bash
make bootstrap-local
make up-local
make logs-local
make down-local

make lint
make validate

make deploy ENV=dev
make destroy ENV=dev
```

## 12) PromQL util

Veja: [`docs/promql-examples.md`](docs/promql-examples.md)

## 13) Guias de resposta

Pasta: `docs/runbooks/`

Inclui guias para:

- EC2InstanceDown
- EC2HighCPUUsage
- EC2DiskWillFillSoon
- ECSServiceRunningTaskMismatch
- EKSNodeNotReady
- EKSPodCrashLoopBackOff
- AppHighErrorRate
- BlackboxEndpointDown
- BlackboxCertificateExpiringSoon
- PrometheusTargetDown

## 14) Lista final de validacao

Arquivo: [`docs/checklist-validation.md`](docs/checklist-validation.md)

## 15) Observacoes para producao

- Trocar certificados self-signed por certificados validos (ACM/PKI).
- Mover secrets para SSM/Secrets Manager.
- Habilitar SSO/OIDC no Grafana.
- Integrar pipeline GitOps com aprovacao para `prod`.
- Ajustar retencao e recursos conforme volume real de metricas.



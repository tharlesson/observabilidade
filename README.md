# AWS Observability Platform (Production-Ready IaC)

Plataforma de observabilidade como código para AWS, com suporte a:

- VMs/EC2
- ECS workloads
- EKS clusters
- Aplicações instrumentadas via OpenTelemetry e `/metrics`

Componentes obrigatórios incluídos neste repositório:

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
- Docker Compose para lab/local

## 1) Características principais

- Observabilidade multi-ambiente (`dev`, `stage`, `prod`)
- Provisionamento versionado com Terraform + Helm
- Grafana com provisioning declarativo (datasources, dashboards, alerting)
- Alertmanager com rotas por severidade (`critical`, `warning`, `info`)
- Inhibit rules, grouping e modelo de silences
- Recording rules para queries pesadas
- Runbooks para alertas críticos
- Suporte a backend central Prometheus-compatible (AMP opcional)
- Lab local com Docker Compose (TLS + auth + persistência)

## 2) Versões pinadas

| Componente | Versão pinada |
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

## 3) Estrutura do repositório

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

## 4) Arquitetura e decisões

Detalhes completos: [`docs/architecture.md`](docs/architecture.md)

Decisões principais:

1. Coleta na borda com ADOT/OTel + exporters para reduzir acoplamento.
2. Backend Prometheus-compatible central via `remote_write`.
3. Dashboard e alerting centralizados no Grafana/Alertmanager OSS.
4. Infra e runtime declarativos (Terraform + Helm + YAML/JSON provisioning).
5. Labels padrão aplicadas em métricas/alertas para governança e roteamento.

## 5) Labels padrão

Todas as métricas e alertas devem usar:

- `environment`
- `cluster`
- `service`
- `namespace`
- `team`
- `severity` (alertas)

Essas labels são reforçadas em:

- Configs de collector (`resource` processor)
- External labels e relabeling no Prometheus
- Rule labels no Prometheus/Grafana

## 6) Monitoramento por domínio

### EC2 / VMs

Inclui:

- `node_exporter` deployment bootstrap via SSM
- Dashboards: CPU, memória, disco, inode, load, rede
- Alertas: indisponibilidade, CPU alta, memória alta, disco enchendo, inode baixo

### ECS

Inclui:

- ADOT Collector como serviço ECS
- Task Role com least privilege
- `ecs_observer` para descoberta automática de tasks
- Coleta OTLP + Prometheus `/metrics`
- Alertas de degradação de serviço e mismatch de tasks

### EKS

Inclui:

- `kube-prometheus-stack` (Prometheus Operator)
- `kube-state-metrics` e `node_exporter`
- ADOT/OTel Collector
- OpenTelemetry Operator opcional
- IRSA para collector
- ServiceMonitor/PodMonitor de exemplo
- Alertas de Node/Pod/Replica health

### Aplicações

Exemplos reais prontos:

- Node.js: `/metrics` + OTLP
- Java (Spring Boot): `/actuator/prometheus` + OTEL Java Agent
- Python (Flask): `/metrics` + OTLP

No lab local, os exemplos sobem com profile `examples` em:
- `http://localhost:8081` (Node)
- `http://localhost:8082` (Python)
- `http://localhost:8083` (Java)

## 7) Dashboards e alerting

### Grafana provisioning

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

### Alertmanager routing

- `critical` -> Slack + Email + Teams webhook
- `warning` -> Slack + Email
- `info` -> Teams/Slack info
- grouping, inhibit rules e mute intervals configurados

## 8) Local lab (Docker Compose)

Guia completo: [`docs/local-lab.md`](docs/local-lab.md)

Passos rápidos:

```bash
cp .env.example .env
make bootstrap-local
make up-local
```

Endpoints:

- Grafana: `https://localhost:3000`
- Prometheus: `https://localhost:9090`
- Alertmanager: `https://localhost:9093`

Credenciais default de laboratório:

- Grafana: `admin / change-me`
- Prometheus: `prom_admin / prom-admin-change-me`
- Alertmanager: `alert_admin / alert-admin-change-me`

Parar lab:

```bash
make down-local
```

## 9) Deploy em AWS

Guia completo: [`docs/deployment-aws.md`](docs/deployment-aws.md)

Fluxo por ambiente:

1. Configurar `terraform.tfvars` e `backend.hcl`
2. `make deploy ENV=dev`
3. Promover para `stage`/`prod`

## 10) Segurança

Guia completo: [`docs/security.md`](docs/security.md)

Inclui baseline de:

- IAM least privilege
- IRSA (EKS) e Task Role (ECS)
- TLS + auth em superfícies sensíveis
- placeholders para secrets
- NetworkPolicy no namespace observability

## 11) Comandos úteis

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

## 12) PromQL úteis

Veja: [`docs/promql-examples.md`](docs/promql-examples.md)

## 13) Runbooks

Pasta: `docs/runbooks/`

Inclui runbooks para:

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

## 14) Checklist final de validação

Arquivo: [`docs/checklist-validation.md`](docs/checklist-validation.md)

## 15) Observações para produção

- Trocar certificados self-signed por certificados válidos (ACM/PKI).
- Mover secrets para SSM/Secrets Manager.
- Habilitar SSO/OIDC no Grafana.
- Integrar pipeline GitOps com aprovação para `prod`.
- Ajustar retenção e recursos por volume real de métricas.

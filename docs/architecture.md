# Arquitetura

## Objetivos

- Uma plataforma de observabilidade reutilizavel para EC2, ECS e EKS.
- Tudo como codigo (Terraform, Helm e provisioning em YAML).
- Isolamento por ambiente em `dev`, `stage` e `prod`.
- Dashboards e alertas centralizados com labels padronizadas.

## Arquitetura logica

1. Coletores de borda:
   - `node_exporter` em EC2/VMs.
   - ADOT Collector no ECS (servico/sidecar com `ecs_observer`).
   - ADOT/OpenTelemetry Collector no EKS (daemonset).
2. Coleta e agregacao:
   - Prometheus Agent ou Prometheus Server nas bordas.
   - Backend central opcional compativel com Prometheus (AMP).
3. Plano de controle:
   - Grafana OSS central com provisioning por arquivo.
   - Alertmanager OSS central com routing/inhibit/grouping/templates.
4. Health checks:
   - `blackbox_exporter` para HTTP/HTTPS/TCP e expiracao de certificado.

## Por que este desenho

- Mantem a coleta perto dos workloads para maior resiliencia e menor egress.
- Suporta operacao hibrida:
  - local/lab com stack OSS em Docker Compose;
  - producao AWS com AMP remote_write e credenciais IAM escopadas.
- Separa responsabilidades:
  - Terraform: infraestrutura, IAM, IRSA e Task Roles do ECS.
  - Helm: configuracoes de runtime no Kubernetes.
  - YAML/JSON de Prometheus/Grafana/Alertmanager: comportamento operacional.

## Modelo de seguranca

- IAM com least privilege:
  - IRSA para collector no EKS.
  - Task Role para collector no ECS.
  - Instance profile para EC2 com SSM + envio de metricas.
- Sem segredo hardcoded:
  - `.env.example`, placeholders de SSM e webhooks.
- TLS e auth nos exemplos de laboratorio para Prometheus/Grafana/Alertmanager.
- Network policies no namespace de observabilidade (deny ingress baseline + allow namespace).

## Padrao de labels

Todas as metricas e alertas devem conter:

- `environment`
- `cluster`
- `service`
- `namespace`
- `team`
- `severity` (alertas)

Este repositorio reforca as labels por:
- processors de recurso do collector;
- external labels e relabeling no Prometheus;
- labels de regras de alerta;
- variaveis de filtro dos dashboards.

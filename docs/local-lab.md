# Laboratorio local

## Pre-requisitos

- Docker + plugin Docker Compose
- OpenSSL
- Opcional: `htpasswd` (caso contrario, o bootstrap usa container httpd)

## Inicio rapido

```bash
cp .env.example .env
make bootstrap-local
make up-local
```

Endpoints:

- Grafana: https://localhost:3000
- Prometheus: https://localhost:9090
- Alertmanager: https://localhost:9093

Credenciais padrao do laboratorio:

- Grafana: `admin / change-me` (sobrescreva via `.env`)
- Basic auth do Prometheus: `prom_admin / prom-admin-change-me`
- Basic auth do Alertmanager: `alert_admin / alert-admin-change-me`

## Apps de exemplo (opcional)

```bash
docker compose -f docker-compose/local-lab/docker-compose.yml --profile examples up -d --build
```

- App Node: http://localhost:8081
- App Python: http://localhost:8082
- App Java: http://localhost:8083

## Parar

```bash
make down-local
```

## Observacoes

- Os certificados TLS sao self-signed e servem apenas para laboratorio.
- Troque as senhas geradas de basic auth em qualquer ambiente compartilhado.
- O laboratorio local usa stack OSS central (sem AMP).

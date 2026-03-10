# Local Lab

## Prerequisites

- Docker + Docker Compose plugin
- OpenSSL
- Optional: `htpasswd` (otherwise bootstrap script uses httpd container)

## Quick Start

```bash
cp .env.example .env
make bootstrap-local
make up-local
```

Endpoints:

- Grafana: https://localhost:3000
- Prometheus: https://localhost:9090
- Alertmanager: https://localhost:9093

Default local lab credentials:

- Grafana: `admin / change-me` (override via `.env`)
- Prometheus basic auth: `prom_admin / prom-admin-change-me`
- Alertmanager basic auth: `alert_admin / alert-admin-change-me`

## Optional Example Apps

```bash
docker compose -f docker-compose/local-lab/docker-compose.yml --profile examples up -d --build
```

- Node sample app: http://localhost:8081
- Python sample app: http://localhost:8082
- Java sample app: http://localhost:8083

## Stop

```bash
make down-local
```

## Notes

- TLS certificates are self-signed for lab only.
- Replace generated basic auth passwords for any shared environment.
- Local lab uses central OSS stack (not AMP).

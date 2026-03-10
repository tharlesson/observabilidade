#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAB_DIR="$ROOT_DIR/docker-compose/local-lab"

if [[ ! -f "$ROOT_DIR/.env" ]]; then
  echo "Missing .env file. Copy .env.example to .env first."
  exit 1
fi

cd "$LAB_DIR"
docker compose pull
docker compose up -d

echo "Local lab is running:"
echo "- Grafana: https://localhost:3000"
echo "- Prometheus: https://localhost:9090"
echo "- Alertmanager: https://localhost:9093"

#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v yamllint >/dev/null 2>&1; then
  yamllint "$ROOT_DIR/alertmanager" "$ROOT_DIR/prometheus" "$ROOT_DIR/otel" "$ROOT_DIR/helm"
else
  echo "yamllint not found. Skipping YAML lint."
fi

if command -v jq >/dev/null 2>&1; then
  for f in "$ROOT_DIR"/grafana/dashboards-json/*.json; do
    jq -e . "$f" >/dev/null
  done
else
  echo "jq not found. Skipping dashboard JSON lint."
fi

echo "Lint completed."

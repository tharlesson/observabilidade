#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <dev|stage|prod|local-lab>"
  exit 1
fi

TARGET="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$TARGET" == "local-lab" ]]; then
  docker compose -f "$ROOT_DIR/docker-compose/local-lab/docker-compose.yml" down -v
  echo "Local lab destroyed"
  exit 0
fi

TF_DIR="$ROOT_DIR/terraform/environments/$TARGET"
if [[ ! -d "$TF_DIR" ]]; then
  echo "Invalid target: $TARGET"
  exit 1
fi

terraform -chdir="$TF_DIR" init -backend-config=backend.hcl
terraform -chdir="$TF_DIR" destroy -auto-approve

echo "Destroy complete for $TARGET"

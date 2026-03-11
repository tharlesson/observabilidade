#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <dev|stage|prod>"
  exit 1
fi

ENV="$1"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="$ROOT_DIR/terraform/environments/$ENV"

if [[ ! -d "$TF_DIR" ]]; then
  echo "Invalid environment: $ENV"
  exit 1
fi

terraform -chdir="$TF_DIR" init -backend-config=backend.hcl
terraform -chdir="$TF_DIR" plan -out=tfplan
terraform -chdir="$TF_DIR" apply tfplan

echo "Deployment complete for $ENV"

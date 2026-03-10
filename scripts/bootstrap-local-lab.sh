#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LAB_DIR="$ROOT_DIR/docker-compose/local-lab"
CERT_DIR="$LAB_DIR/certs"
PROM_WEB="$LAB_DIR/prometheus/web.yml"
ALERT_WEB="$LAB_DIR/alertmanager/web.yml"

mkdir -p "$CERT_DIR"

if [[ ! -f "$ROOT_DIR/.env" ]]; then
  cp "$ROOT_DIR/.env.example" "$ROOT_DIR/.env"
  echo "Created .env from .env.example"
fi

if [[ ! -f "$CERT_DIR/tls.crt" || ! -f "$CERT_DIR/tls.key" ]]; then
  openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes \
    -keyout "$CERT_DIR/tls.key" \
    -out "$CERT_DIR/tls.crt" \
    -subj "/CN=localhost"
  echo "Generated self-signed certs in $CERT_DIR"
fi

hash_password() {
  local user="$1"
  local pass="$2"

  if command -v htpasswd >/dev/null 2>&1; then
    htpasswd -bnBC 12 "$user" "$pass" | cut -d: -f2
  else
    docker run --rm httpd:2.4-alpine htpasswd -bnBC 12 "$user" "$pass" | cut -d: -f2
  fi
}

PROM_HASH="$(hash_password prom_admin 'prom-admin-change-me')"
ALERT_HASH="$(hash_password alert_admin 'alert-admin-change-me')"

# Escape replacement for sed
PROM_HASH_ESCAPED="${PROM_HASH//\//\\/}"
ALERT_HASH_ESCAPED="${ALERT_HASH//\//\\/}"

sed -i.bak "s|\$2y\$12\$replace_with_bcrypt_hash|${PROM_HASH_ESCAPED}|g" "$PROM_WEB"
sed -i.bak "s|\$2y\$12\$replace_with_bcrypt_hash|${ALERT_HASH_ESCAPED}|g" "$ALERT_WEB"
rm -f "$PROM_WEB.bak" "$ALERT_WEB.bak"

echo "Bootstrap complete."
echo "Prometheus basic auth user: prom_admin"
echo "Alertmanager basic auth user: alert_admin"
echo "Remember to rotate default passwords before production use."

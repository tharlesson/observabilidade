param(
  [string]$PromPassword = "prom-admin-change-me",
  [string]$AlertPassword = "alert-admin-change-me"
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path "$PSScriptRoot/..").Path
$lab = Join-Path $root "docker-compose/local-lab"
$certDir = Join-Path $lab "certs"
$promWeb = Join-Path $lab "prometheus/web.yml"
$alertWeb = Join-Path $lab "alertmanager/web.yml"

if (-not (Test-Path $certDir)) {
  New-Item -ItemType Directory -Path $certDir | Out-Null
}

$envFile = Join-Path $root ".env"
if (-not (Test-Path $envFile)) {
  Copy-Item (Join-Path $root ".env.example") $envFile
  Write-Host "Created .env from .env.example"
}

$crt = Join-Path $certDir "tls.crt"
$key = Join-Path $certDir "tls.key"
if (-not (Test-Path $crt) -or -not (Test-Path $key)) {
  openssl req -x509 -newkey rsa:4096 -sha256 -days 365 -nodes `
    -keyout $key `
    -out $crt `
    -subj "/CN=localhost" | Out-Null
  Write-Host "Generated self-signed certs"
}

function New-BcryptHash {
  param(
    [string]$User,
    [string]$Password
  )

  $line = docker run --rm httpd:2.4-alpine htpasswd -bnBC 12 $User $Password
  return ($line -split ":")[1]
}

$promHash = New-BcryptHash -User "prom_admin" -Password $PromPassword
$alertHash = New-BcryptHash -User "alert_admin" -Password $AlertPassword

(Get-Content $promWeb -Raw).Replace("`$2y`$12`$replace_with_bcrypt_hash", $promHash) | Set-Content $promWeb -Encoding UTF8
(Get-Content $alertWeb -Raw).Replace("`$2y`$12`$replace_with_bcrypt_hash", $alertHash) | Set-Content $alertWeb -Encoding UTF8

Write-Host "Bootstrap complete"
Write-Host "Prometheus user: prom_admin"
Write-Host "Alertmanager user: alert_admin"

# Runbook: Certificate Expiring Soon

## Alert
`BlackboxCertificateExpiringSoon`

## Triage
1. Identify certificate owner and renewal process.
2. Confirm SAN/CN match and chain validity.
3. Validate automation (ACM/cert-manager/PKI pipeline).

## Mitigation
1. Renew certificate.
2. Deploy updated certificate and key.
3. Validate HTTPS handshake and chain.

## Verify
- Cert expiry > 14 days and probe remains successful.

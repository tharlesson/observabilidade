# Guia de resposta: Certificado proximo de expirar

## Alerta
`BlackboxCertificateExpiringSoon`

## Triagem
1. Identifique o owner do certificado e o processo de renovacao.
2. Confirme SAN/CN e validade da cadeia.
3. Valide automacao (ACM/cert-manager/pipeline de PKI).

## Mitigacao
1. Renove o certificado.
2. Publique certificado e chave atualizados.
3. Valide handshake HTTPS e cadeia.

## Validacao
- Expiracao acima de 14 dias e probe continua com sucesso.


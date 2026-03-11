# Guia de resposta: Endpoint Blackbox indisponivel

## Alerta
`BlackboxEndpointDown`

## Triagem
1. Confirme indisponibilidade por visao externa e interna.
2. Verifique DNS, certificado TLS e saude de ingress/load balancer.
3. Revise mudancas recentes de rede/firewall.

## Mitigacao
1. Faca failover para endpoint/regiao saudavel.
2. Restaure ingress ou servico de backend.
3. Atualize roteamento/allowlist.

## Validacao
- `probe_success` volta para `1`.


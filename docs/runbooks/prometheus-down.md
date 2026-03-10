# Guia de resposta: Prometheus indisponivel

## Alerta
`PrometheusTargetDown`

## Triagem
1. Verifique status e logs de container/pod.
2. Valide disponibilidade de disco e saude da TSDB.
3. Verifique alteracoes recentes de sintaxe em config/rules.

## Mitigacao
1. Reinicie o servico.
2. Faça rollback da ultima alteracao de config/rules.
3. Recupere volume ou aumente armazenamento.

## Validacao
- `up{job="prometheus"} == 1` e targets/rules retomam.


# Guia de resposta: Instancia EC2 indisponivel

## Alerta
`EC2InstanceDown`

## Impacto
Metricas do host indisponiveis; possivel falha de no ou rede.

## Triagem
1. Confirme estado da instancia no Console/CLI da AWS.
2. Verifique alteracoes de security group e rotas.
3. Valide processo/servico do `node_exporter`.
4. Confirme se o Prometheus alcanca o target em `:9100`.

## Mitigacao
1. Reinicie a instancia ou recupere via Auto Scaling.
2. Reinicie o servico `node_exporter`.
3. Corrija regras de rede/seguranca.

## Validacao da recuperacao
- `up{job="node-exporter",instance="<instance>"} == 1`


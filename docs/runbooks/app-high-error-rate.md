# Guia de resposta: Taxa alta de erro na aplicacao

## Alerta
`AppHighErrorRate` / `ECSServiceHighErrorRate`

## Triagem
1. Quebre os erros por rota/status/versao.
2. Correlacione com a linha do tempo de deploys.
3. Verifique dependencias downstream.

## Mitigacao
1. Faca rollback do deploy com problema.
2. Habilite caminho de degradacao/fallback.
3. Aumente retries/circuit breaker onde for seguro.

## Validacao
- Razao de 5xx abaixo do limite por pelo menos 10 minutos.


# Guia de resposta: Divergencia de tarefas no ECS

## Alerta
`ECSServiceRunningTaskMismatch`

## Triagem
1. Compare desired vs running por servico.
2. Inspecione eventos recentes do ECS para falhas de health/placement.
3. Valide imagem/env/secrets da task definition.

## Mitigacao
1. Faça rollback da ultima task definition em caso de regressao.
2. Aumente capacidade/providers.
3. Corrija health checks com falha.

## Validacao
- Quantidade running igual a desired por 10 minutos.


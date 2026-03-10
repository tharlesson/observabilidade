# Guia de resposta: CPU alta no EC2

## Alerta
`EC2HighCPUUsage`

## Triagem
1. Identifique processos com maior consumo (`top`, `pidstat`).
2. Correlacione com deploys ou jobs agendados.
3. Avalie saturacao em toda a frota.

## Mitigacao
1. Escale horizontalmente quando a carga justificar.
2. Ajuste configuracao de workers/threads da aplicacao.
3. Defina limites/requests de CPU para workloads ruidosos.

## Validacao
- Uso de CPU abaixo do limite por pelo menos 10 minutos.


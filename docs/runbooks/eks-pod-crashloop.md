# Guia de resposta: Pod em CrashLoopBackOff no EKS

## Alerta
`EKSPodCrashLoopBackOff`

## Triagem
1. Verifique logs do pod e logs anteriores.
2. Inspecione command/config/env do container e deploy recente.
3. Valide dependencias (DB/cache/API).

## Mitigacao
1. Faça rollback do deployment.
2. Corrija config/secret/env.
3. Aumente recursos se estiver relacionado a OOM.

## Validacao
- Contagem de CrashLoop reduz e pod permanece Running.


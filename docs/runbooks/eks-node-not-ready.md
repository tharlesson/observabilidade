# Guia de resposta: Node EKS NotReady

## Alerta
`EKSNodeNotReady`

## Triagem
1. Execute `kubectl describe node <node>` para condicoes/eventos.
2. Verifique saude do kubelet e runtime de containers.
3. Valide eventos de escala do node group.

## Mitigacao
1. Drene e recicle o node.
2. Corrija problemas de CNI/DNS/runtime.
3. Escale o node group se houver restricao de capacidade.

## Validacao
- Condicao do node em `Ready=True` e workloads reescalonados.


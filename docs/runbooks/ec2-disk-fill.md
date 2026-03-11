# Guia de resposta: Disco do EC2 enchendo

## Alerta
`EC2DiskWillFillSoon`

## Triagem
1. Verifique uso de disco por mount e diretorios principais.
2. Valide politicas de rotacao e retencao de logs.
3. Inspecione arquivos descontrolados e diretorios temporarios.

## Mitigacao
1. Limpe arquivos desnecessarios.
2. Aumente volume e filesystem.
3. Mova logs/artefatos para object storage.

## Validacao
- Consulta preditiva nao projeta mais esgotamento em 24h.


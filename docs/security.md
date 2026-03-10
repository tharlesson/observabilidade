# Baseline de seguranca

## Identidade e acesso

- IRSA no EKS para o collector ADOT.
- Task role do ECS para o collector ADOT.
- Instance profile no EC2 para bootstrap de node_exporter/collector.
- Permissoes de escrita no AMP escopadas ao ARN do workspace sempre que possivel.

## Secrets

- Nenhum segredo armazenado no repositorio.
- Use `.env` somente no laboratorio local.
- Em producao, prefira AWS SSM Parameter Store ou Secrets Manager.

## Controles de rede

- Baseline de NetworkPolicy no namespace de observabilidade.
- Security groups dos collectors no ECS restritos ao egress necessario.
- Endpoints do blackbox devem ser explicitamente allowlisted.

## Seguranca de transporte

- Exemplos TLS para Prometheus, Grafana e Alertmanager no laboratorio local.
- Em producao AWS, use certificados gerenciados e terminacao TLS no ingress.

## Hardening recomendado para producao

- Substituir certificados self-signed por certificados ACM/publicos/CA privada.
- Usar WAF + ingress privado para Grafana/Alertmanager.
- Forcar SSO/OIDC no Grafana.
- Adicionar verificacao de assinatura de imagem e politicas de admissao.

# Lista de validacao

## Infraestrutura

- [ ] Terraform apply executa com sucesso no ambiente alvo.
- [ ] Workspace AMP existe (quando `backend_mode=amp`).
- [ ] Role de IRSA vinculada ao service account do collector no EKS.
- [ ] Servico ADOT no ECS com quantidade desejada de tasks em execucao.
- [ ] Associacao SSM aplicada nas instancias EC2 com tag alvo.

## Coleta de dados

- [ ] Targets de `node_exporter` estao `UP`.
- [ ] Targets de `kube-state-metrics` estao `UP`.
- [ ] Probes do blackbox geram `probe_success`.
- [ ] Telemetria OTLP chega ao collector.
- [ ] Fila de remote_write do Prometheus sem falhas sustentadas.

## Dashboards

- [ ] Dashboard de EC2 mostra CPU/memoria/disco/rede de host.
- [ ] Dashboard de ECS mostra tarefas desired/running e uso de recursos.
- [ ] Dashboard de EKS mostra saude de node/pod/deployment.
- [ ] Dashboard de blackbox mostra disponibilidade e expiracao de certificado.
- [ ] Dashboard de self-monitoring mostra saude da stack principal.

## Alertas

- [ ] Roteamento de severidades critical/warning/info funcionando.
- [ ] Inhibit rules suprimindo ruido de alertas filhos corretamente.
- [ ] Grouping reduzindo notificacoes duplicadas.
- [ ] Criacao de silence testada por API/UI.

## Seguranca

- [ ] Nenhum segredo em texto puro commitado.
- [ ] Certificados TLS validos para todos os endpoints expostos.
- [ ] Basic auth/SSO habilitados para superficies administrativas.
- [ ] Politicas IAM com least privilege e escopo correto.


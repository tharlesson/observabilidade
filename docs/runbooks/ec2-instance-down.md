# Runbook: EC2 Instance Down

## Alert
`EC2InstanceDown`

## Impact
Host metrics unavailable; possible node or network outage.

## Triage
1. Confirm instance state in AWS Console/CLI.
2. Check security group and route changes.
3. Validate `node_exporter` process/service.
4. Verify Prometheus can reach target on `:9100`.

## Mitigation
1. Restart instance or recover via Auto Scaling.
2. Restart `node_exporter` service.
3. Fix network/security rules.

## Verify Recovery
- `up{job="node-exporter",instance="<instance>"} == 1`

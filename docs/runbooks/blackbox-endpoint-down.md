# Runbook: Blackbox Endpoint Down

## Alert
`BlackboxEndpointDown`

## Triage
1. Confirm endpoint outage from external and internal vantage points.
2. Check DNS, TLS cert, ingress/load balancer health.
3. Review recent network/firewall changes.

## Mitigation
1. Failover to healthy endpoint/region.
2. Restore ingress or backend service.
3. Update routing/allowlist.

## Verify
- `probe_success` returns to `1`.

# Runbook: Prometheus Down

## Alert
`PrometheusTargetDown`

## Triage
1. Check container/pod status and logs.
2. Validate disk availability and TSDB health.
3. Verify config/rules syntax changes.

## Mitigation
1. Restart service.
2. Roll back last config/rules change.
3. Recover volume or increase storage.

## Verify
- `up{job="prometheus"} == 1` and targets/rules resume.

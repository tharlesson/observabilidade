# Runbook: Application High Error Rate

## Alert
`AppHighErrorRate` / `ECSServiceHighErrorRate`

## Triage
1. Break down errors by route/status/version.
2. Correlate with deployment timeline.
3. Check downstream dependencies.

## Mitigation
1. Roll back bad deploy.
2. Enable degradation/fallback path.
3. Increase retries/circuit breaker where safe.

## Verify
- 5xx ratio below threshold for 10m.

# Runbook: ECS Running Task Mismatch

## Alert
`ECSServiceRunningTaskMismatch`

## Triage
1. Compare desired vs running tasks per service.
2. Inspect recent ECS events for placement or health failures.
3. Validate task definition image/env/secret references.

## Mitigation
1. Roll back last task definition if regression.
2. Increase capacity/providers.
3. Fix failing health checks.

## Verify
- Running count matches desired count for 10m.

# Runbook: EKS Pod CrashLoopBackOff

## Alert
`EKSPodCrashLoopBackOff`

## Triage
1. Check pod logs and previous logs.
2. Inspect container command/config/env and recent deploy.
3. Validate dependencies (DB/cache/API).

## Mitigation
1. Roll back deployment.
2. Fix config/secret/env.
3. Increase resources if OOM-related.

## Verify
- CrashLoop count drops and pod stays Running.

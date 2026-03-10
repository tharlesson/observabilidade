# Runbook: EC2 High CPU

## Alert
`EC2HighCPUUsage`

## Triage
1. Identify top CPU processes (`top`, `pidstat`).
2. Correlate with deploys or cron jobs.
3. Check saturation across fleet.

## Mitigation
1. Scale out if load-driven.
2. Tune app worker/thread config.
3. Add CPU limits/requests for noisy workloads.

## Verify
- CPU usage returns below threshold for at least 10m.

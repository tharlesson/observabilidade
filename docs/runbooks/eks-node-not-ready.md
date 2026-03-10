# Runbook: EKS Node Not Ready

## Alert
`EKSNodeNotReady`

## Triage
1. `kubectl describe node <node>` for conditions/events.
2. Check kubelet/container runtime health.
3. Validate node group scaling events.

## Mitigation
1. Drain and recycle node.
2. Fix CNI/DNS/runtime issues.
3. Scale node group if capacity constrained.

## Verify
- Node condition `Ready=True` and workloads rescheduled.

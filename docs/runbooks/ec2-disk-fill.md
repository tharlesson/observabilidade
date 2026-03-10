# Runbook: EC2 Disk Filling

## Alert
`EC2DiskWillFillSoon`

## Triage
1. Check disk usage by mount and top directories.
2. Validate log rotation and retention settings.
3. Inspect runaway files and temp folders.

## Mitigation
1. Clean unnecessary files.
2. Increase volume size and filesystem.
3. Move logs/artifacts to object storage.

## Verify
- Predictive fill query no longer projects exhaustion within 24h.

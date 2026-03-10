# Component: Prometheus

## Purpose

- Scrape metrics from exporters/apps.
- Evaluate recording rules and alerts.
- Forward alerts to Alertmanager.
- Optional remote_write to AMP.

## Config Files

- `prometheus/prometheus.yml`
- `prometheus/rules/*.yaml`
- `prometheus/recording-rules/*.yaml`
- `prometheus/scrape-configs/*.yaml`
- `prometheus/web.yml`

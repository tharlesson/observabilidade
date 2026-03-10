# Exemplos de PromQL

## EC2 / VM

```promql
100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

```promql
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

```promql
predict_linear(node_filesystem_avail_bytes{mountpoint="/"}[6h], 24 * 3600)
```

## ECS

```promql
aws_ecs_service_desired_task_count - aws_ecs_service_running_task_count
```

```promql
aws_ecs_service_cpu_utilization_average
```

## EKS

```promql
kube_node_status_condition{condition="Ready",status="true"} == 0
```

```promql
kube_deployment_spec_replicas - kube_deployment_status_replicas_available
```

```promql
sum by(namespace) (kube_pod_status_phase{phase="Pending"})
```

## SLOs de aplicacao

```promql
sum(rate(http_server_requests_total{status_code=~"5.."}[5m])) / clamp_min(sum(rate(http_server_requests_total[5m])), 1)
```

```promql
histogram_quantile(0.95, sum by(le, service) (rate(http_server_duration_seconds_bucket[5m])))
```

```promql
sum by(service) (rate(http_server_requests_total[5m]))
```

## Blackbox

```promql
probe_success
```

```promql
probe_duration_seconds
```

```promql
(probe_ssl_earliest_cert_expiry - time()) / 86400
```

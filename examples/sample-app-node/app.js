const express = require('express');
const client = require('prom-client');

const { NodeSDK } = require('@opentelemetry/sdk-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-grpc');
const { OTLPMetricExporter } = require('@opentelemetry/exporter-metrics-otlp-grpc');
const { PeriodicExportingMetricReader } = require('@opentelemetry/sdk-metrics');
const { getNodeAutoInstrumentations } = require('@opentelemetry/auto-instrumentations-node');
const { resourceFromAttributes } = require('@opentelemetry/resources');
const { SemanticResourceAttributes } = require('@opentelemetry/semantic-conventions');

const port = process.env.PORT || 8080;

const resource = resourceFromAttributes({
  [SemanticResourceAttributes.SERVICE_NAME]: process.env.OTEL_SERVICE_NAME || 'sample-app-node',
  [SemanticResourceAttributes.DEPLOYMENT_ENVIRONMENT]: process.env.ENVIRONMENT || 'dev',
  cluster: process.env.CLUSTER || 'local-lab',
  team: process.env.TEAM || 'platform'
});

const metricReader = new PeriodicExportingMetricReader({
  exporter: new OTLPMetricExporter({
    url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://otel-collector:4317'
  }),
  exportIntervalMillis: 15000
});

const sdk = new NodeSDK({
  resource,
  traceExporter: new OTLPTraceExporter({
    url: process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://otel-collector:4317'
  }),
  metricReader,
  instrumentations: [getNodeAutoInstrumentations()]
});

sdk.start();

const app = express();

const registry = new client.Registry();
client.collectDefaultMetrics({ register: registry });

const httpRequestsTotal = new client.Counter({
  name: 'http_server_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code', 'service', 'environment', 'cluster', 'team'],
  registers: [registry]
});

const httpRequestDuration = new client.Histogram({
  name: 'http_server_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route', 'status_code', 'service', 'environment', 'cluster', 'team'],
  buckets: [0.05, 0.1, 0.25, 0.5, 1, 2, 5],
  registers: [registry]
});

app.use((req, res, next) => {
  const end = httpRequestDuration.startTimer();
  res.on('finish', () => {
    const labels = {
      method: req.method,
      route: req.route?.path || req.path,
      status_code: String(res.statusCode),
      service: process.env.OTEL_SERVICE_NAME || 'sample-app-node',
      environment: process.env.ENVIRONMENT || 'dev',
      cluster: process.env.CLUSTER || 'local-lab',
      team: process.env.TEAM || 'platform'
    };

    httpRequestsTotal.inc(labels, 1);
    end(labels);
  });
  next();
});

app.get('/', async (_req, res) => {
  await new Promise((resolve) => setTimeout(resolve, 80));
  res.json({
    message: 'Hello from sample-app-node',
    environment: process.env.ENVIRONMENT || 'dev'
  });
});

app.get('/slow', async (_req, res) => {
  await new Promise((resolve) => setTimeout(resolve, 1200));
  res.json({ status: 'slow endpoint ok' });
});

app.get('/error', (_req, res) => {
  res.status(500).json({ error: 'simulated error' });
});

app.get('/healthz', (_req, res) => {
  res.status(200).send('ok');
});

app.get('/metrics', async (_req, res) => {
  res.set('Content-Type', registry.contentType);
  res.end(await registry.metrics());
});

const server = app.listen(port, () => {
  // eslint-disable-next-line no-console
  console.log(`sample-app-node listening on port ${port}`);
});

const shutdown = async () => {
  server.close(async () => {
    await sdk.shutdown();
    process.exit(0);
  });
};

process.on('SIGINT', shutdown);
process.on('SIGTERM', shutdown);

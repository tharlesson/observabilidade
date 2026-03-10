import os
import time
from flask import Flask, Response, jsonify
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

from opentelemetry import trace
from opentelemetry.sdk.resources import Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.instrumentation.flask import FlaskInstrumentor

app = Flask(__name__)

RESOURCE = Resource.create(
    {
        "service.name": os.getenv("OTEL_SERVICE_NAME", "sample-app-python"),
        "deployment.environment": os.getenv("ENVIRONMENT", "dev"),
        "cluster": os.getenv("CLUSTER", "local-lab"),
        "team": os.getenv("TEAM", "platform"),
    }
)

provider = TracerProvider(resource=RESOURCE)
provider.add_span_processor(
    BatchSpanProcessor(
        OTLPSpanExporter(
            endpoint=os.getenv("OTEL_EXPORTER_OTLP_ENDPOINT", "http://otel-collector:4317"),
            insecure=os.getenv("OTEL_EXPORTER_OTLP_INSECURE", "true").lower() == "true",
        )
    )
)
trace.set_tracer_provider(provider)

FlaskInstrumentor().instrument_app(app)

REQUESTS = Counter(
    "http_server_requests_total",
    "Total HTTP requests",
    ["method", "route", "status_code", "service", "environment", "cluster", "team"],
)
LATENCY = Histogram(
    "http_server_duration_seconds",
    "HTTP latency in seconds",
    ["method", "route", "status_code", "service", "environment", "cluster", "team"],
    buckets=(0.05, 0.1, 0.25, 0.5, 1.0, 2.0, 5.0),
)


def _labels(route: str, status_code: int):
    return {
        "method": "GET",
        "route": route,
        "status_code": str(status_code),
        "service": os.getenv("OTEL_SERVICE_NAME", "sample-app-python"),
        "environment": os.getenv("ENVIRONMENT", "dev"),
        "cluster": os.getenv("CLUSTER", "local-lab"),
        "team": os.getenv("TEAM", "platform"),
    }


@app.get("/")
def home():
    start = time.time()
    payload = {
        "message": "Hello from sample-app-python",
        "environment": os.getenv("ENVIRONMENT", "dev"),
    }
    labels = _labels("/", 200)
    REQUESTS.labels(**labels).inc()
    LATENCY.labels(**labels).observe(time.time() - start)
    return jsonify(payload)


@app.get("/healthz")
def healthz():
    labels = _labels("/healthz", 200)
    REQUESTS.labels(**labels).inc()
    LATENCY.labels(**labels).observe(0.001)
    return "ok", 200


@app.get("/error")
def error_route():
    labels = _labels("/error", 500)
    REQUESTS.labels(**labels).inc()
    LATENCY.labels(**labels).observe(0.010)
    return jsonify({"error": "simulated error"}), 500


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.getenv("PORT", "8080")))

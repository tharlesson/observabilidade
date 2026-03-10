# Sample App Java

- Spring Boot app exposing:
  - `/`
  - `/healthz`
  - `/error`
  - `/actuator/prometheus`
- OpenTelemetry auto-instrumentation via Java Agent.

## Run

```bash
mvn spring-boot:run
```

## Docker

```bash
docker build -t sample-app-java .
docker run --rm -p 8080:8080 --env-file .env.example sample-app-java
```

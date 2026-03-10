# App de exemplo em Java

- Aplicacao Spring Boot com os endpoints:
  - `/`
  - `/healthz`
  - `/error`
  - `/actuator/prometheus`
- Auto-instrumentacao OpenTelemetry via Java Agent.

## Executar

```bash
mvn spring-boot:run
```

## Docker

```bash
docker build -t sample-app-java .
docker run --rm -p 8080:8080 --env-file .env.example sample-app-java
```

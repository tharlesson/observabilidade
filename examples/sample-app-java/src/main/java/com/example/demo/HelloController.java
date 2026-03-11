package com.example.demo;

import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

  @GetMapping("/")
  public Map<String, String> hello() {
    return Map.of(
        "message", "Hello from sample-app-java",
        "environment", System.getenv().getOrDefault("ENVIRONMENT", "dev"));
  }

  @GetMapping("/healthz")
  public String health() {
    return "ok";
  }

  @GetMapping("/error")
  @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
  public Map<String, String> error() {
    return Map.of("error", "simulated error");
  }
}

import client from "prom-client";
import http from "http";
import { logger } from "../logging/logger.js";

/**
 * Prometheus metrics for FUELRUSH API.
 * Exposed on a separate port (9090) for scraping.
 */

// Enable default metrics (CPU, memory, event loop, etc.)
client.collectDefaultMetrics({
  prefix: "fuelrush_",
  labels: { service: "fuelrush-api" },
});

// ── Custom Metrics ──

/** HTTP request counter. */
export const httpRequestCounter = new client.Counter({
  name: "fuelrush_http_requests_total",
  help: "Total number of HTTP requests",
  labelNames: ["method", "route", "status_code"],
});

/** HTTP request duration histogram. */
export const httpRequestDuration = new client.Histogram({
  name: "fuelrush_http_request_duration_seconds",
  help: "HTTP request duration in seconds",
  labelNames: ["method", "route", "status_code"],
  buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
});

/** Active WebSocket connections gauge. */
export const activeConnections = new client.Gauge({
  name: "fuelrush_active_connections",
  help: "Number of active WebSocket connections",
  labelNames: ["type"],
});

/** Order creation counter. */
export const ordersCreated = new client.Counter({
  name: "fuelrush_orders_created_total",
  help: "Total number of orders created",
  labelNames: ["fuel_type", "status"],
});

/** Payment processing counter. */
export const paymentsProcessed = new client.Counter({
  name: "fuelrush_payments_processed_total",
  help: "Total number of payments processed",
  labelNames: ["method", "status"],
});

/** OTP sent counter. */
export const otpSent = new client.Counter({
  name: "fuelrush_otp_sent_total",
  help: "Total number of OTPs sent",
  labelNames: ["status"],
});

/** Database query duration. */
export const dbQueryDuration = new client.Histogram({
  name: "fuelrush_db_query_duration_seconds",
  help: "Database query duration in seconds",
  labelNames: ["operation", "model"],
  buckets: [0.001, 0.005, 0.01, 0.05, 0.1, 0.5, 1],
});

/** Redis operation duration. */
export const redisOperationDuration = new client.Histogram({
  name: "fuelrush_redis_operation_duration_seconds",
  help: "Redis operation duration in seconds",
  labelNames: ["operation"],
  buckets: [0.001, 0.005, 0.01, 0.05, 0.1, 0.5],
});

/**
 * Start the metrics HTTP server on a separate port.
 */
export function startMetricsServer(port: number): void {
  const metricsServer = http.createServer(async (_req, res) => {
    try {
      res.setHeader("Content-Type", client.register.contentType);
      const metrics = await client.register.metrics();
      res.end(metrics);
    } catch (err) {
      res.statusCode = 500;
      res.end("Error collecting metrics");
    }
  });

  metricsServer.listen(port, () => {
    logger.info({ msg: `📊 Prometheus metrics server running`, port });
  });
}
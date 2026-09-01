import "dotenv/config";
import express from "express";
import http from "http";
import cors from "cors";
import helmet from "helmet";
import { Server as SocketIOServer } from "socket.io";
import { logger } from "./logging/logger.js";
import { requestLogger } from "./logging/requestLogger.js";
import { errorHandler } from "./middleware/errorHandler.js";
import { apiRateLimit } from "./middleware/rateLimit.js";
import routes from "./routes/index.js";
import { initializeSocket } from "./sockets/index.js";
import { startMetricsServer } from "./monitoring/metrics.js";
import { runHealthChecks } from "./monitoring/healthChecks.js";
import redis from "./config/redis.js";
import { setSocketServer } from "./services/trackingService.js";

const PORT = parseInt(process.env.PORT ?? "3000", 10);
const NODE_ENV = process.env.NODE_ENV ?? "development";

async function bootstrap(): Promise<void> {
  const app = express();
  const server = http.createServer(app);

  // ── Socket.io Setup ──
  const io = new SocketIOServer(server, {
    cors: {
      origin: NODE_ENV === "production"
        ? ["https://app.fuelrush.com", "https://admin.fuelrush.com"]
        : ["*"],
      methods: ["GET", "POST"],
      credentials: true,
    },
    pingTimeout: 60000,
    pingInterval: 25000,
    maxHttpBufferSize: 1e6, // 1MB
  });

  // ── Security Middleware ──
  app.use(helmet({
    contentSecurityPolicy: NODE_ENV === "production" ? undefined : false,
    crossOriginEmbedderPolicy: false,
  }));

  app.use(cors({
    origin: NODE_ENV === "production"
      ? ["https://app.fuelrush.com", "https://admin.fuelrush.com"]
      : "*",
    credentials: true,
    methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization", "X-Device-Fingerprint", "X-Device-Id", "X-App-Version"],
  }));

  // ── Body Parsing ──
  app.use(express.json({ limit: "10mb" }));
  app.use(express.urlencoded({ extended: true, limit: "10mb" }));

  // ── Request Logging (Pino) ──
  app.use(requestLogger);

  // ── Global Rate Limiting ──
  app.use(apiRateLimit);

  // ── Health Check (before routes — no auth needed) ──
  app.get("/health", async (_req, res) => {
    const checks = await runHealthChecks();
    const isHealthy = checks.every((c) => c.status === "ok");
    res.status(isHealthy ? 200 : 503).json({
      status: isHealthy ? "healthy" : "degraded",
      timestamp: new Date().toISOString(),
      version: process.env.APP_VERSION ?? "1.0.0",
      environment: NODE_ENV,
      checks,
    });
  });

  // ── API Routes ──
  app.use(`/api/${process.env.API_VERSION ?? "v1"}`, routes);

  // ── 404 Handler ──
  app.use((_req, res) => {
    res.status(404).json({
      error: "NOT_FOUND",
      message: "Endpoint not found",
      timestamp: new Date().toISOString(),
    });
  });

  // ── Global Error Handler ──
  app.use(errorHandler);

  // ── Initialize Socket.io ──
  initializeSocket(io);
  setSocketServer(io);

  // ── Start Prometheus Metrics Server ──
  startMetricsServer(9090);

  // ── Verify Redis Connection ──
  try {
    await redis.ping();
    logger.info("🔴 Redis connected");
  } catch (err) {
    logger.error({ err }, "🔴 Redis connection failed");
  }

  // ── Start Server ──
  server.listen(PORT, () => {
    logger.info({
      msg: `🚀 FUELRUSH API Server running`,
      port: PORT,
      env: NODE_ENV,
      version: process.env.APP_VERSION ?? "1.0.0",
      healthUrl: `http://localhost:${PORT}/health`,
      metricsUrl: `http://localhost:9090/metrics`,
    });
  });

  // ── Graceful Shutdown ──
  const shutdown = async (signal: string): Promise<void> => {
    logger.info({ msg: `${signal} received. Starting graceful shutdown...` });

    server.close(async () => {
      logger.info("HTTP server closed");

      try {
        await redis.quit();
        logger.info("Redis connection closed");
      } catch {
        logger.warn("Redis close error (non-fatal)");
      }

      io.close();
      logger.info("Socket.io closed");

      logger.info("✅ Graceful shutdown complete");
      process.exit(0);
    });

    // Force shutdown after 10 seconds
    setTimeout(() => {
      logger.error("Forced shutdown after timeout");
      process.exit(1);
    }, 10000);
  };

  process.on("SIGTERM", () => shutdown("SIGTERM"));
  process.on("SIGINT", () => shutdown("SIGINT"));

  process.on("unhandledRejection", (reason) => {
    logger.error({ reason }, "Unhandled Rejection");
  });

  process.on("uncaughtException", (error) => {
    logger.fatal({ error: error.message, stack: error.stack }, "Uncaught Exception");
    process.exit(1);
  });
}

bootstrap().catch((err) => {
  console.error("Failed to start server:", err);
  process.exit(1);
});
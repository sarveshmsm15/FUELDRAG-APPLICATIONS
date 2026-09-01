import { Router, Request, Response } from "express";
import prisma from "../../config/database.js";
import redis from "../../config/redis.js";
import { asyncHandler } from "../../middleware/errorHandler.js";

const router = Router();

/**
 * GET /api/v1/health/detailed
 * Detailed health check with individual component status.
 */
router.get(
  "/detailed",
  asyncHandler(async (_req: Request, res: Response) => {
    const checks: Record<string, { status: string; latencyMs: number; details?: string }> = {};

    // Check PostgreSQL
    const dbStart = Date.now();
    try {
      await prisma.$queryRaw`SELECT 1`;
      checks.postgres = { status: "ok", latencyMs: Date.now() - dbStart };
    } catch (err) {
      checks.postgres = {
        status: "error",
        latencyMs: Date.now() - dbStart,
        details: err instanceof Error ? err.message : "Unknown error",
      };
    }

    // Check Redis
    const redisStart = Date.now();
    try {
      await redis.ping();
      checks.redis = { status: "ok", latencyMs: Date.now() - redisStart };
    } catch (err) {
      checks.redis = {
        status: "error",
        latencyMs: Date.now() - redisStart,
        details: err instanceof Error ? err.message : "Unknown error",
      };
    }

    // Memory usage
    const memUsage = process.memoryUsage();
    checks.memory = {
      status: memUsage.heapUsed < 500 * 1024 * 1024 ? "ok" : "warning",
      latencyMs: 0,
      details: `Heap: ${(memUsage.heapUsed / 1024 / 1024).toFixed(1)}MB / ${(memUsage.heapTotal / 1024 / 1024).toFixed(1)}MB`,
    };

    // Uptime
    checks.uptime = {
      status: "ok",
      latencyMs: 0,
      details: `${(process.uptime() / 3600).toFixed(2)} hours`,
    };

    const allOk = Object.values(checks).every((c) => c.status === "ok");

    res.status(allOk ? 200 : 503).json({
      status: allOk ? "healthy" : "degraded",
      timestamp: new Date().toISOString(),
      version: process.env.APP_VERSION ?? "1.0.0",
      environment: process.env.NODE_ENV ?? "development",
      checks,
    });
  }),
);

/**
 * GET /api/v1/health/ping
 * Simple ping endpoint for load balancer checks.
 */
router.get("/ping", (_req: Request, res: Response) => {
  res.json({ pong: true, timestamp: new Date().toISOString() });
});

export default router;
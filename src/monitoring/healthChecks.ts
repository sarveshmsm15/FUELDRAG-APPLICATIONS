import prisma from "../config/database.js";
import redis from "../config/redis.js";

interface HealthCheck {
  name: string;
  status: "ok" | "error" | "warning";
  latencyMs: number;
  details?: string;
}


export async function runHealthChecks(): Promise<HealthCheck[]> {
  const checks: HealthCheck[] = [];

  // PostgreSQL check
  const dbStart = Date.now();
  try {
    await prisma.$queryRaw`SELECT 1`;
    checks.push({
      name: "postgresql",
      status: "ok",
      latencyMs: Date.now() - dbStart,
    });
  } catch (err) {
    checks.push({
      name: "postgresql",
      status: "error",
      latencyMs: Date.now() - dbStart,
      details: err instanceof Error ? err.message : "Connection failed",
    });
  }


  const redisStart = Date.now();
  try {
    await redis.ping();
    checks.push({
      name: "redis",
      status: "ok",
      latencyMs: Date.now() - redisStart,
    });
  } catch (err) {
    checks.push({
      name: "redis",
      status: "error",
      latencyMs: Date.now() - redisStart,
      details: err instanceof Error ? err.message : "Connection failed",
    });
  }


  const memUsage = process.memoryUsage();
  const heapUsedMB = memUsage.heapUsed / 1024 / 1024;
  checks.push({
    name: "memory",
    status: heapUsedMB > 500 ? "warning" : "ok",
    latencyMs: 0,
    details: `Heap: ${heapUsedMB.toFixed(1)}MB`,
  });

  
  checks.push({
    name: "runtime",
    status: "ok",
    latencyMs: 0,
    details: `Node ${process.version}, Uptime ${(process.uptime() / 3600).toFixed(2)}h`,
  });

  return checks;
}
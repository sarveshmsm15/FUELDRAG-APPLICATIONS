import { Request, Response, NextFunction } from "express";
import redis from "../config/redis.js";

interface RateLimitOptions {
  maxRequests: number;
  windowSeconds: number;
  prefix: string;
  keyExtractor?: (req: Request) => string;
}

export function rateLimit(options: RateLimitOptions) {
  const { maxRequests, windowSeconds, prefix, keyExtractor } = options;

  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const identifier = keyExtractor ? keyExtractor(req) : req.ip ?? "unknown";
      const key = `${prefix}:${identifier}:${req.path}`;
      const now = Date.now();
      const windowStart = now - windowSeconds * 1000;

      const multi = redis.multi();
      multi.zremrangebyscore(key, 0, windowStart);
      multi.zcard(key);
      multi.zadd(key, now.toString(), `${now}:${Math.random()}`);
      multi.expire(key, windowSeconds);

      const results = await multi.exec();
      const requestCount = (results?.[1]?.[1] as number) ?? 0;

      res.setHeader("X-RateLimit-Limit", maxRequests.toString());
      res.setHeader("X-RateLimit-Remaining", Math.max(0, maxRequests - requestCount - 1).toString());

      if (requestCount >= maxRequests) {
        res.status(429).json({
          error: "Too Many Requests",
          message: `Rate limit exceeded. Try again in ${windowSeconds} seconds.`,
          retryAfter: windowSeconds,
        });
        return;
      }

      next();
    } catch (error) {
      console.error("Rate limit check failed:", error);
      next();
    }
  };
}

// Dev-friendly limits — increase for production
export const apiRateLimit = rateLimit({
  maxRequests: 1000,
  windowSeconds: 60,
  prefix: "rl:api",
});

export const authRateLimit = rateLimit({
  maxRequests: 100,
  windowSeconds: 60,
  prefix: "rl:auth",
});

export const otpRateLimit = rateLimit({
  maxRequests: 100,
  windowSeconds: 60,
  prefix: "rl:otp",
});

export const paymentRateLimit = rateLimit({
  maxRequests: 100,
  windowSeconds: 60,
  prefix: "rl:payment",
});
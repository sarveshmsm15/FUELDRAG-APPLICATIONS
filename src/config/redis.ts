import Redis from 'ioredis';

const REDIS_URL = process.env.REDIS_URL ?? 'redis://localhost:6379';

/**
 * Redis Client Singleton.
 * Used for caching, rate limiting, session storage, and pub/sub.
 */
export const redis: Redis = new Redis(REDIS_URL, {
  maxRetriesPerRequest: 3,
  retryStrategy(times: number): number | null {
    if (times > 10) return null; // Stop retrying after 10 attempts
    return Math.min(times * 200, 3000);
  },
  lazyConnect: true,
});

redis.on('connect', () => {
  console.log('🔴 Redis connected');
});

redis.on('error', (err: Error) => {
  console.error('🔴 Redis error:', err.message);
});

redis.on('close', () => {
  console.log('🔴 Redis connection closed');
});

/**
 * Typed Redis helpers for FUELRUSH.
 */
export const RedisKeys = {
  /** OTP storage: otp:{phone} → {otp, attempts, expiry} */
  otp: (phone: string): string => `otp:${phone}`,

  /** Rate limit: ratelimit:{identifier}:{endpoint} */
  rateLimit: (identifier: string, endpoint: string): string =>
    `ratelimit:${identifier}:${endpoint}`,

  /** Active session: session:{refreshToken} */
  session: (refreshToken: string): string => `session:${refreshToken}`,

  /** Fuel rate cache: fuelrate:{fuelType}:{region} */
  fuelRate: (fuelType: string, region: string): string =>
    `fuelrate:${fuelType}:${region}`,

  /** Price lock: pricelock:{orderId} */
  priceLock: (orderId: string): string => `pricelock:${orderId}`,

  /** Driver location: driverloc:{driverId} */
  driverLocation: (driverId: string): string => `driverloc:${driverId}`,

  /** Idempotency key: idempotency:{key} */
  idempotency: (key: string): string => `idempotency:${key}`,

  /** User throttle: throttle:{userId}:{action} */
  throttle: (userId: string, action: string): string =>
    `throttle:${userId}:${action}`,
} as const;

export default redis;
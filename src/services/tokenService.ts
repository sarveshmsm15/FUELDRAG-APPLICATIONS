import { verifyAccessToken, verifyRefreshToken, decodeToken } from "../security/jwt.js";
import redis, { RedisKeys } from "../config/redis.js";

/**
 * Token introspection service.
 * Used for validating tokens in WebSocket connections and background jobs.
 */
export function introspectAccessToken(token: string) {
  try {
    const payload = verifyAccessToken(token);
    return { valid: true, payload };
  } catch (error) {
    return {
      valid: false,
      error: error instanceof Error ? error.message : "Unknown error",
    };
  }
}

/**
 * Check if a refresh token is still active in Redis.
 */
export async function isRefreshTokenActive(refreshToken: string): Promise<boolean> {
  const cached = await redis.get(RedisKeys.session(refreshToken));
  return cached !== null;
}

/**
 * Get remaining TTL for a token (for client-side display).
 */
export function getTokenRemainingTtl(token: string): number | null {
  const decoded = decodeToken(token);
  if (!decoded?.exp) return null;
  const remaining = decoded.exp - Math.floor(Date.now() / 1000);
  return Math.max(0, remaining);
}
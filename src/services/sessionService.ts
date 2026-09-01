import crypto from "crypto";
import prisma from "../config/database.js";
import { generateTokenPair, verifyRefreshToken, TokenPair } from "../security/jwt.js";
import redis, { RedisKeys } from "../config/redis.js";

const REFRESH_TOKEN_TTL_SECONDS = 30 * 24 * 60 * 60; // 30 days

/**
 * Create a new session and return token pair.
 */
export async function createSession(
  userId: string,
  role: string,
  deviceFingerprint?: string,
  ipAddress?: string,
  userAgent?: string,
): Promise<TokenPair & { sessionId: string }> {
  const sessionId = crypto.randomUUID();
  const refreshTokenHash = crypto.randomUUID(); // Placeholder until tokens generated

  const tokenPair = generateTokenPair(userId, role, sessionId, deviceFingerprint);

  // Store session in database
  await prisma.session.create({
    data: {
      id: sessionId,
      userId,
      refreshToken: tokenPair.refreshToken,
      deviceFingerprint,
      ipAddress,
      userAgent,
      expiresAt: tokenPair.refreshExpiresAt,
    },
  });

  // Cache in Redis for fast lookup
  await redis.set(
    RedisKeys.session(tokenPair.refreshToken),
    JSON.stringify({ userId, sessionId, deviceFingerprint }),
    "EX",
    REFRESH_TOKEN_TTL_SECONDS,
  );

  return { ...tokenPair, sessionId };
}

/**
 * Refresh tokens — single-use rotation.
 * Old refresh token is revoked, new pair is issued.
 */
export async function refreshSession(
  refreshToken: string,
  deviceFingerprint?: string,
): Promise<TokenPair & { sessionId: string }> {
  // Verify the refresh token signature
  const payload = verifyRefreshToken(refreshToken);

  // Check if session exists and is not revoked
  const session = await prisma.session.findUnique({
    where: { id: payload.sessionId },
    include: { user: true },
  });

  if (!session) {
    throw new Error("Session not found");
  }

  if (session.isRevoked) {
    // Possible token theft — revoke all sessions for this user
    await prisma.session.updateMany({
      where: { userId: session.userId, isRevoked: false },
      data: { isRevoked: true },
    });
    throw new Error("Session already revoked — possible token theft detected");
  }

  if (session.expiresAt < new Date()) {
    throw new Error("Session expired");
  }

  // Verify device fingerprint matches
  if (session.deviceFingerprint && deviceFingerprint && session.deviceFingerprint !== deviceFingerprint) {
    throw new Error("Device fingerprint mismatch");
  }

  // Revoke old session (single-use)
  await prisma.session.update({
    where: { id: session.id },
    data: { isRevoked: true },
  });

  // Remove old from Redis
  await redis.del(RedisKeys.session(refreshToken));

  // Create new session with new tokens
  return createSession(
    session.userId,
    session.user.role,
    deviceFingerprint ?? session.deviceFingerprint ?? undefined,
    session.ipAddress ?? undefined,
    session.userAgent ?? undefined,
  );
}

/**
 * Revoke a specific session (logout).
 */
export async function revokeSession(sessionId: string): Promise<void> {
  await prisma.session.update({
    where: { id: sessionId },
    data: { isRevoked: true },
  });
}

/**
 * Revoke all sessions for a user (force logout everywhere).
 */
export async function revokeAllSessions(userId: string): Promise<void> {
  const sessions = await prisma.session.findMany({
    where: { userId, isRevoked: false },
    select: { refreshToken: true },
  });

  await prisma.session.updateMany({
    where: { userId, isRevoked: false },
    data: { isRevoked: true },
  });

  // Clear from Redis
  const pipeline = redis.pipeline();
  for (const session of sessions) {
    pipeline.del(RedisKeys.session(session.refreshToken));
  }
  await pipeline.exec();
}

/**
 * Clean up expired sessions (run as cron job).
 */
export async function cleanupExpiredSessions(): Promise<number> {
  const result = await prisma.session.deleteMany({
    where: {
      OR: [{ expiresAt: { lt: new Date() } }, { isRevoked: true }],
    },
  });
  return result.count;
}
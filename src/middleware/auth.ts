import { Request, Response, NextFunction } from "express";
import { verifyAccessToken, AccessTokenPayload } from "../security/jwt.js";

// Extend Express Request to include authenticated user
declare global {
  namespace Express {
    interface Request {
      user?: AccessTokenPayload;
    }
  }
}

/**
 * JWT authentication middleware.
 * Extracts and verifies Bearer token from Authorization header.
 * Attaches decoded payload to req.user.
 */
export function authenticate(
  req: Request,
  res: Response,
  next: NextFunction,
): void {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).json({
      error: "Unauthorized",
      message: "Missing or invalid Authorization header",
      code: "AUTH_MISSING_TOKEN",
    });
    return;
  }

  const token = authHeader.slice(7); // Remove "Bearer "

  try {
    const payload = verifyAccessToken(token);

    // Optional: verify device fingerprint matches
    if (payload.deviceFingerprint) {
      const requestFingerprint = req.headers["x-device-fingerprint"] as string;
      if (requestFingerprint && requestFingerprint !== payload.deviceFingerprint) {
        res.status(401).json({
          error: "Unauthorized",
          message: "Device mismatch",
          code: "AUTH_DEVICE_MISMATCH",
        });
        return;
      }
    }

    req.user = payload;
    next();
  } catch (error) {
    const message = error instanceof Error ? error.message : "Invalid token";
    const isExpired = message.includes("expired");

    res.status(401).json({
      error: "Unauthorized",
      message: isExpired ? "Token expired" : "Invalid token",
      code: isExpired ? "AUTH_TOKEN_EXPIRED" : "AUTH_INVALID_TOKEN",
    });
  }
}

/**
 * Optional authentication — doesn't fail if no token present.
 * Useful for endpoints that work both authenticated and unauthenticated.
 */
export function optionalAuth(
  req: Request,
  _res: Response,
  next: NextFunction,
): void {
  const authHeader = req.headers.authorization;

  if (authHeader && authHeader.startsWith("Bearer ")) {
    try {
      const token = authHeader.slice(7);
      req.user = verifyAccessToken(token);
    } catch {
      // Silently ignore invalid tokens for optional auth
    }
  }

  next();
}
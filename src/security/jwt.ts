import crypto from "crypto";
import fs from "fs";
import path from "path";
import jwt from "jsonwebtoken";

// ── Load RSA Keys ──
const keysDir = path.resolve(__dirname, "../../keys");

let privateKey: string;
let publicKey: string;

try {
  privateKey = fs.readFileSync(path.join(keysDir, "jwt-private.pem"), "utf8");
  publicKey = fs.readFileSync(path.join(keysDir, "jwt-public.pem"), "utf8");
} catch {
  // Fallback for development — generate ephemeral keys
  const { privateKey: priv, publicKey: pub } = crypto.generateKeyPairSync(
    "rsa",
    { modulusLength: 2048 },
  );
  privateKey = priv.export({ type: "pkcs1", format: "pem" }) as string;
  publicKey = pub.export({ type: "spki", format: "pem" }) as string;
  console.warn(
    "⚠️  Using ephemeral RSA keys. Generate persistent keys for production.",
  );
}

// ── Token Payloads ──
export interface AccessTokenPayload {
  sub: string; // userId
  role: string;
  deviceFingerprint?: string;
  type: "access";
}

export interface RefreshTokenPayload {
  sub: string; // userId
  sessionId: string;
  deviceFingerprint?: string;
  type: "refresh";
}

export interface TokenPair {
  accessToken: string;
  refreshToken: string;
  accessExpiresAt: Date;
  refreshExpiresAt: Date;
}

// ── Configuration ──
const ACCESS_EXPIRY = process.env.JWT_ACCESS_EXPIRY ?? "15m";
const REFRESH_EXPIRY = process.env.JWT_REFRESH_EXPIRY ?? "30d";

/**
 * Generate an access + refresh token pair.
 * Access: RS256, short-lived (15 min default).
 * Refresh: RS256, long-lived (30 days default), single-use.
 */
export function generateTokenPair(
  userId: string,
  role: string,
  sessionId: string,
  deviceFingerprint?: string,
): TokenPair {
  const now = Math.floor(Date.now() / 1000);

  const accessPayload: AccessTokenPayload = {
    sub: userId,
    role,
    deviceFingerprint,
    type: "access",
  };

  const refreshPayload: RefreshTokenPayload = {
    sub: userId,
    sessionId,
    deviceFingerprint,
    type: "refresh",
  };

  const accessToken = jwt.sign(accessPayload, privateKey, {
    algorithm: "RS256",
    expiresIn: ACCESS_EXPIRY,
    jwtid: crypto.randomUUID(),
  });

  const refreshToken = jwt.sign(refreshPayload, privateKey, {
    algorithm: "RS256",
    expiresIn: REFRESH_EXPIRY,
    jwtid: crypto.randomUUID(),
  });

  // Decode to get exact expiry timestamps
  const accessDecoded = jwt.decode(accessToken) as jwt.JwtPayload;
  const refreshDecoded = jwt.decode(refreshToken) as jwt.JwtPayload;

  return {
    accessToken,
    refreshToken,
    accessExpiresAt: new Date((accessDecoded.exp ?? now + 900) * 1000),
    refreshExpiresAt: new Date((refreshDecoded.exp ?? now + 2592000) * 1000),
  };
}

/**
 * Verify and decode an access token.
 * Throws JsonWebTokenError on invalid/expired tokens.
 */
export function verifyAccessToken(token: string): AccessTokenPayload {
  const decoded = jwt.verify(token, publicKey, {
    algorithms: ["RS256"],
  }) as jwt.JwtPayload & AccessTokenPayload;

  if (decoded.type !== "access") {
    throw new Error("Invalid token type: expected access token");
  }

  return decoded;
}

/**
 * Verify and decode a refresh token.
 */
export function verifyRefreshToken(token: string): RefreshTokenPayload {
  const decoded = jwt.verify(token, publicKey, {
    algorithms: ["RS256"],
  }) as jwt.JwtPayload & RefreshTokenPayload;

  if (decoded.type !== "refresh") {
    throw new Error("Invalid token type: expected refresh token");
  }

  return decoded;
}

/**
 * Decode a token without verification (for logging/debugging only).
 */
export function decodeToken(
  token: string,
): jwt.JwtPayload | null {
  return jwt.decode(token) as jwt.JwtPayload | null;
}
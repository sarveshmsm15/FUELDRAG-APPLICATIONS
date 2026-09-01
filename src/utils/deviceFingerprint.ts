import crypto from "crypto";
import { Request } from "express";

/**
 * Generate a device fingerprint from request headers.
 * Used for device binding — tokens are tied to the device that created them.
 */
export function generateDeviceFingerprint(req: Request): string {
  const components = [
    req.headers["user-agent"] ?? "",
    req.headers["x-device-id"] ?? "",
    req.headers["x-device-brand"] ?? "",
    req.headers["x-device-model"] ?? "",
    req.headers["x-os-version"] ?? "",
    req.headers["x-app-version"] ?? "",
    req.ip ?? req.socket.remoteAddress ?? "",
  ];

  const raw = components.join("|");
  return crypto.createHash("sha256").update(raw).digest("hex").slice(0, 32);
}

/**
 * Compare two fingerprints with tolerance.
 * Returns true if they match (same device).
 */
export function fingerprintsMatch(a: string, b: string): boolean {
  return a === b;
}
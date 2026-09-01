import { Request, Response, NextFunction } from "express";
import prisma from "../config/database.js";
import { AuditAction } from "../generated/prisma/client.js";

/**
 * Audit logging middleware.
 * Logs all mutating requests (POST, PUT, PATCH, DELETE) to audit_logs table.
 */
export function auditLog(action: AuditAction, entityType: string) {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    // Capture original json to intercept response
    const originalJson = res.json.bind(res);

    res.json = function (body: unknown) {
      // Log asynchronously — don't block the response
      setImmediate(async () => {
        try {
          await prisma.auditLog.create({
            data: {
              userId: req.user?.sub ?? null,
              action,
              entityType,
              entityId: extractEntityId(body),
              newValues: sanitizeForAudit(req.body),
              ipAddress: req.ip ?? req.socket.remoteAddress ?? null,
              userAgent: req.headers["user-agent"] ?? null,
              metadata: {
                method: req.method,
                path: req.originalUrl,
                statusCode: res.statusCode,
              },
            },
          });
        } catch (error) {
          console.error("Audit log failed:", error);
        }
      });

      return originalJson(body);
    } as Response["json"];

    next();
  };
}

/** Extract entity ID from response body. */
function extractEntityId(body: unknown): string | null {
  if (body && typeof body === "object") {
    const obj = body as Record<string, unknown>;
    if (typeof obj.id === "string") return obj.id;
    if (obj.data && typeof obj.data === "object") {
      const data = obj.data as Record<string, unknown>;
      if (typeof data.id === "string") return data.id;
    }
  }
  return null;
}

/** Remove sensitive fields before storing in audit log. */
function sanitizeForAudit(
  body: unknown,
): Record<string, unknown> | null {
  if (!body || typeof body !== "object") return null;

  const sanitized = { ...(body as Record<string, unknown>) };
  const sensitiveFields = [
    "password",
    "pin",
    "otp",
    "token",
    "refreshToken",
    "accessToken",
    "creditCard",
    "cvv",
  ];

  for (const field of sensitiveFields) {
    if (field in sanitized) {
      sanitized[field] = "[REDACTED]";
    }
  }

  return sanitized;
}
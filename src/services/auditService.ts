import prisma from "../config/database.js";
import { AuditAction } from "../generated/prisma/client.js";
import { maskPhone, maskEmail, maskName } from "../security/encryption.js";

interface AuditEntry {
  userId?: string | null;
  action: AuditAction;
  entityType: string;
  entityId?: string | null;
  oldValues?: Record<string, unknown> | null;
  newValues?: Record<string, unknown> | null;
  ipAddress?: string | null;
  userAgent?: string | null;
  metadata?: Record<string, unknown> | null;
}

/**
 * Audit service for programmatic audit logging.
 * Use this when you need to log events outside of middleware.
 */
export async function createAuditLog(entry: AuditEntry): Promise<void> {
  try {
    await prisma.auditLog.create({
      data: {
        userId: entry.userId ?? null,
        action: entry.action,
        entityType: entry.entityType,
        entityId: entry.entityId ?? null,
        oldValues: entry.oldValues ?? undefined,
        newValues: entry.newValues ?? undefined,
        ipAddress: entry.ipAddress ?? null,
        userAgent: entry.userAgent ?? null,
        metadata: entry.metadata ?? undefined,
      },
    });
  } catch (error) {
    // Never let audit logging crash the app
    console.error("Failed to create audit log:", error);
  }
}

/**
 * Get paginated audit logs with optional filters.
 */
export async function getAuditLogs(filters: {
  userId?: string;
  action?: AuditAction;
  entityType?: string;
  page?: number;
  pageSize?: number;
}) {
  const { userId, action, entityType, page = 1, pageSize = 20 } = filters;
  const skip = (page - 1) * pageSize;

  const where: Record<string, unknown> = {};
  if (userId) where.userId = userId;
  if (action) where.action = action;
  if (entityType) where.entityType = entityType;

  const [logs, total] = await Promise.all([
    prisma.auditLog.findMany({
      where,
      orderBy: { createdAt: "desc" },
      skip,
      take: pageSize,
      include: { user: { select: { id: true, name: true, phone: true } } },
    }),
    prisma.auditLog.count({ where }),
  ]);

  // Mask PII in audit results
  const maskedLogs = logs.map((log) => ({
    ...log,
    user: log.user
      ? {
          ...log.user,
          phone: maskPhone(log.user.phone),
          name: log.user.name ? maskName(log.user.name) : null,
        }
      : null,
  }));

  return {
    data: maskedLogs,
    pagination: {
      page,
      pageSize,
      total,
      totalPages: Math.ceil(total / pageSize),
    },
  };
}
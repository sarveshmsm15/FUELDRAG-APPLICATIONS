import prisma from "../config/database.js";
import { createSession } from "./sessionService.js";
import { hashPin, verifyPin } from "../security/password.js";
import { encrypt, decrypt, maskPhone } from "../security/encryption.js";
import { createAuditLog } from "./auditService.js";
import { AuditAction } from "../generated/prisma/client.js";
import { logger } from "../logging/logger.js";

/**
 * Find or create user by phone number.
 */
export async function findOrCreateUser(phone: string): Promise<{
  id: string;
  phone: string;
  role: string;
  isNew: boolean;
  name: string | null;
  email: string | null;
}> {
  let user = await prisma.user.findUnique({ where: { phone } });

  if (!user) {
    user = await prisma.user.create({
      data: {
        phone,
        encryptedPhone: encrypt(phone),
        role: "customer",
        isVerified: false,
      },
    });

    // Create wallet for new user
    await prisma.wallet.create({
      data: { userId: user.id, balance: 0, currency: "INR" },
    });

    await createAuditLog({
      userId: user.id,
      action: AuditAction.create,
      entityType: "user",
      entityId: user.id,
      newValues: { phone: maskPhone(phone) },
    });

    logger.info({ msg: "New user created", userId: user.id, phone: maskPhone(phone) });

    return { id: user.id, phone: user.phone, role: user.role, isNew: true, name: null, email: null };
  }

  // Update last login
  await prisma.user.update({
    where: { id: user.id },
    data: { lastLoginAt: new Date() },
  });

  return {
    id: user.id,
    phone: user.phone,
    role: user.role,
    isNew: false,
    name: user.name,
    email: user.email,
  };
}

/**
 * Complete login — create session and return tokens.
 */
export async function loginUser(
  userId: string,
  role: string,
  deviceFingerprint?: string,
  ipAddress?: string,
  userAgent?: string,
) {
  const session = await createSession(userId, role, deviceFingerprint, ipAddress, userAgent);

  await createAuditLog({
    userId,
    action: AuditAction.login,
    entityType: "session",
    entityId: session.sessionId,
    ipAddress,
    userAgent,
  });

  return {
    accessToken: session.accessToken,
    refreshToken: session.refreshToken,
    accessExpiresAt: session.accessExpiresAt,
    refreshExpiresAt: session.refreshExpiresAt,
  };
}

/**
 * Update user profile after OTP verification.
 */
export async function updateProfile(
  userId: string,
  data: { name?: string; email?: string },
) {
  const updateData: Record<string, unknown> = {};

  if (data.name) {
    updateData.name = data.name;
    updateData.encryptedName = encrypt(data.name);
  }
  if (data.email) {
    updateData.email = data.email;
    updateData.encryptedEmail = encrypt(data.email);
  }

  updateData.isVerified = true;

  const user = await prisma.user.update({
    where: { id: userId },
    data: updateData,
  });

  await createAuditLog({
    userId,
    action: AuditAction.update,
    entityType: "user",
    entityId: userId,
    newValues: { name: data.name, email: data.email ? maskEmail(data.email) : undefined },
  });

  return {
    id: user.id,
    phone: user.phone,
    name: user.name,
    email: user.email,
    role: user.role,
    isVerified: user.isVerified,
  };
}

function maskEmail(email: string): string {
  const [name, domain] = email.split("@");
  return `${name?.[0]}***@${domain}`;
}

/**
 * Setup PIN for a user.
 */
export async function setupPin(userId: string, pin: string): Promise<void> {
  const pinHash = await hashPin(pin);
  await prisma.user.update({
    where: { id: userId },
    data: { pinHash },
  });

  await createAuditLog({
    userId,
    action: AuditAction.update,
    entityType: "user",
    entityId: userId,
    newValues: { pinHash: "[SET]" },
  });
}

/**
 * Verify user PIN.
 */
export async function verifyUserPin(userId: string, pin: string): Promise<boolean> {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: { pinHash: true },
  });

  if (!user?.pinHash) return false;
  return verifyPin(pin, user.pinHash);
}

/**
 * Enable biometric for a user.
 */
export async function enableBiometric(userId: string): Promise<void> {
  await prisma.user.update({
    where: { id: userId },
    data: { biometricEnabled: true },
  });
}

/**
 * Get user profile (with masked PII for non-owners).
 */
export async function getUserProfile(userId: string) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    select: {
      id: true,
      phone: true,
      name: true,
      email: true,
      avatarUrl: true,
      role: true,
      isVerified: true,
      biometricEnabled: true,
      pinHash: true,
      createdAt: true,
    },
  });

  if (!user) return null;

  return {
    ...user,
    phone: maskPhone(user.phone),
    hasPin: !!user.pinHash,
    pinHash: undefined,
  };
}
import crypto from "crypto";
import redis, { RedisKeys } from "../config/redis.js";
import { logger } from "../logging/logger.js";
import { config } from "../config/app.js";

interface OtpData {
  otp: string;
  attempts: number;
  createdAt: number;
}

const OTP_LENGTH = 6;
const OTP_EXPIRY_SECONDS = config.otp.expiryMinutes * 60;
const OTP_MAX_ATTEMPTS = 5;
const RATE_LIMIT_SECONDS = 60; 

/**
 * Generate a cryptographically secure 6-digit OTP.
 */
function generateOtp(): string {
  return crypto.randomInt(100000, 999999).toString();
}

/**
 * Send OTP — stores in Redis with expiry.
 * Rate limited: max 3 per hour per phone.
 */
export async function sendOtp(phone: string): Promise<{ success: boolean; message: string }> {
  const key = RedisKeys.otp(phone);
  const rateLimitKey = `otp_rate:${phone}`;

  // Check rate limit
  const currentCount = await redis.get(rateLimitKey);
  if (currentCount && parseInt(currentCount, 10) >= 100) {
    const ttl = await redis.ttl(rateLimitKey);
    logger.warn({ msg: "OTP rate limited", phone: phone.slice(0, 3) + "*****" + phone.slice(-3), ttl });
    return {
      success: false,
      message: `Too many OTP requests. Try again in ${Math.ceil(ttl / 60)} minutes.`,
    };
  }

  // Generate and store OTP
  const otp = generateOtp();
  const otpData: OtpData = {
    otp,
    attempts: 0,
    createdAt: Date.now(),
  };

  await redis.set(key, JSON.stringify(otpData), "EX", OTP_EXPIRY_SECONDS);
  await redis.incr(rateLimitKey);
  await redis.expire(rateLimitKey, RATE_LIMIT_SECONDS);

  logger.info({
    msg: "OTP generated",
    phone: phone.slice(0, 3) + "*****" + phone.slice(-3),
    otp: config.isDevelopment ? otp : "[HIDDEN]", // Only log in dev
    expiresIn: `${config.otp.expiryMinutes} min`,
  });

  // TODO Phase 5+: Send via Twilio SMS
  // For now, in development, we just log it

  return {
    success: true,
    message: config.isDevelopment
      ? `OTP sent successfully. Dev OTP: ${otp}`
      : "OTP sent to your phone number.",
  };
}

/**
 * Verify OTP — checks against Redis, tracks attempts.
 */
export async function verifyOtp(
  phone: string,
  otp: string,
): Promise<{ success: boolean; message: string }> {
  const key = RedisKeys.otp(phone);
  const raw = await redis.get(key);

  if (!raw) {
    return { success: false, message: "OTP expired or not found. Request a new one." };
  }

  const otpData: OtpData = JSON.parse(raw);

  // Check expiry
  const elapsed = (Date.now() - otpData.createdAt) / 1000;
  if (elapsed > OTP_EXPIRY_SECONDS) {
    await redis.del(key);
    return { success: false, message: "OTP expired. Request a new one." };
  }

  // Check max attempts
  if (otpData.attempts >= OTP_MAX_ATTEMPTS) {
    await redis.del(key);
    return { success: false, message: "Too many failed attempts. Request a new OTP." };
  }

  // Verify
  if (otpData.otp !== otp) {
    otpData.attempts += 1;
    await redis.set(key, JSON.stringify(otpData), "EX", Math.ceil(OTP_EXPIRY_SECONDS - elapsed));

    const remaining = OTP_MAX_ATTEMPTS - otpData.attempts;
    return {
      success: false,
      message: `Invalid OTP. ${remaining} attempt${remaining !== 1 ? "s" : ""} remaining.`,
    };
  }

  // Success — delete OTP (single use)
  await redis.del(key);

  logger.info({ msg: "OTP verified successfully", phone: phone.slice(0, 3) + "*****" + phone.slice(-3) });

  return { success: true, message: "OTP verified successfully." };
}

/**
 * Check if an OTP exists for a phone (for resend logic).
 */
export async function hasActiveOtp(phone: string): Promise<boolean> {
  const key = RedisKeys.otp(phone);
  return (await redis.exists(key)) === 1;
}
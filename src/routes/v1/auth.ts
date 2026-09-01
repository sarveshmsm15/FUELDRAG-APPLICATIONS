import { Router, Request, Response } from "express";
import { z } from "zod";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { validateBody } from "../../middleware/validation.js";
import { authenticate } from "../../middleware/auth.js";
import { otpRateLimit, authRateLimit } from "../../middleware/rateLimit.js";
import { auditLog } from "../../middleware/audit.js";
import { BaseController } from "../../controllers/baseController.js";
import { sendOtp, verifyOtp } from "../../services/otpService.js";
import { findOrCreateUser, loginUser, updateProfile, setupPin, verifyUserPin, enableBiometric, getUserProfile } from "../../services/authService.js";
import { refreshSession, revokeAllSessions } from "../../services/sessionService.js";
import { AuditAction } from "../../generated/prisma/client.js";
import { Errors } from "../../middleware/errorHandler.js";

const router = Router();

// ── Schemas ──
const sendOtpSchema = z.object({
  phone: z.string().regex(/^[6-9]\d{9}$/, "Enter a valid 10-digit Indian phone number"),
});

const verifyOtpSchema = z.object({
  phone: z.string().regex(/^[6-9]\d{9}$/, "Invalid phone number"),
  otp: z.string().regex(/^\d{6}$/, "OTP must be 6 digits"),
});

const updateProfileSchema = z.object({
  name: z.string().min(2).max(50).optional(),
  email: z.string().email().optional().or(z.literal("")),
});

const setupPinSchema = z.object({
  pin: z.string().regex(/^\d{6}$/, "PIN must be 6 digits"),
});

const verifyPinSchema = z.object({
  pin: z.string().regex(/^\d{6}$/, "PIN must be 6 digits"),
});

const refreshTokenSchema = z.object({
  refreshToken: z.string().min(10),
});

// ── POST /auth/send-otp ──
router.post(
  "/send-otp",
  otpRateLimit,
  validateBody(sendOtpSchema),
  asyncHandler(async (req: Request, res: Response) => {
    const { phone } = req.body;
    const result = await sendOtp(phone);

    if (!result.success) {
      throw Errors.badRequest(result.message);
    }

    BaseController.success(res, { message: result.message });
  }),
);

// ── POST /auth/verify-otp ──
router.post(
  "/verify-otp",
  authRateLimit,
  validateBody(verifyOtpSchema),
  auditLog(AuditAction.login, "auth"),
  asyncHandler(async (req: Request, res: Response) => {
    const { phone, otp } = req.body;

    // Verify OTP
    const otpResult = await verifyOtp(phone, otp);
    if (!otpResult.success) {
      throw Errors.badRequest(otpResult.message);
    }

    // Find or create user
    const user = await findOrCreateUser(phone);

    // Login — create session
    const deviceFingerprint = req.headers["x-device-fingerprint"] as string | undefined;
    const tokens = await loginUser(
      user.id,
      user.role,
      deviceFingerprint,
      req.ip ?? undefined,
      req.headers["user-agent"] ?? undefined,
    );

    BaseController.success(res, {
      user: {
        id: user.id,
        phone: user.phone,
        name: user.name,
        email: user.email,
        role: user.role,
        isNew: user.isNew,
      },
      ...tokens,
    });
  }),
);

// ── POST /auth/refresh ──
router.post(
  "/refresh",
  validateBody(refreshTokenSchema),
  asyncHandler(async (req: Request, res: Response) => {
    const { refreshToken } = req.body;
    const deviceFingerprint = req.headers["x-device-fingerprint"] as string | undefined;

    try {
      const tokens = await refreshSession(refreshToken, deviceFingerprint);
      BaseController.success(res, tokens);
    } catch (err) {
      throw Errors.unauthorized(err instanceof Error ? err.message : "Invalid refresh token");
    }
  }),
);

// ── POST /auth/logout ──
router.post(
  "/logout",
  authenticate,
  auditLog(AuditAction.logout, "auth"),
  asyncHandler(async (req: Request, res: Response) => {
    if (req.user) {
      await revokeAllSessions(req.user.sub);
    }
    BaseController.success(res, { message: "Logged out successfully" });
  }),
);

// ── PUT /auth/profile ──
router.put(
  "/profile",
  authenticate,
  validateBody(updateProfileSchema),
  auditLog(AuditAction.update, "user"),
  asyncHandler(async (req: Request, res: Response) => {
    const profile = await updateProfile(req.user!.sub, req.body);
    BaseController.success(res, profile);
  }),
);

// ── GET /auth/me ──
router.get(
  "/me",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const profile = await getUserProfile(req.user!.sub);
    if (!profile) throw Errors.notFound("User");
    BaseController.success(res, profile);
  }),
);

// ── POST /auth/pin/setup ──
router.post(
  "/pin/setup",
  authenticate,
  validateBody(setupPinSchema),
  auditLog(AuditAction.update, "pin"),
  asyncHandler(async (req: Request, res: Response) => {
    await setupPin(req.user!.sub, req.body.pin);
    BaseController.success(res, { message: "PIN set successfully" });
  }),
);

// ── POST /auth/pin/verify ──
router.post(
  "/pin/verify",
  authenticate,
  authRateLimit,
  validateBody(verifyPinSchema),
  asyncHandler(async (req: Request, res: Response) => {
    const isValid = await verifyUserPin(req.user!.sub, req.body.pin);
    if (!isValid) throw Errors.unauthorized("Invalid PIN");
    BaseController.success(res, { valid: true });
  }),
);

// ── POST /auth/biometric/setup ──
router.post(
  "/biometric/setup",
  authenticate,
  auditLog(AuditAction.update, "biometric"),
  asyncHandler(async (req: Request, res: Response) => {
    await enableBiometric(req.user!.sub);
    BaseController.success(res, { message: "Biometric enabled" });
  }),
);

export default router;
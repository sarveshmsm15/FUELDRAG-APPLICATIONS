import crypto from "crypto";
import prisma from "../config/database.js";
import { PaymentMethod, PaymentStatus } from "../generated/prisma/client.js";
import { debitWallet } from "./walletService.js";
import { verifyUserPin } from "./authService.js";
import redis, { RedisKeys } from "../config/redis.js";
import { logger } from "../logging/logger.js";

interface PaymentInput {
  orderId: string;
  userId: string;
  method: PaymentMethod;
  amount: number;
  pin?: string; // Required for wallet payments above threshold
}

/**
 * Initiate payment — idempotent via idempotency key.
 */
export async function initiatePayment(input: PaymentInput): Promise<{
  success: boolean;
  paymentId: string;
  status: string;
  message: string;
}> {
  const { orderId, userId, method, amount, pin } = input;

  // Generate idempotency key
  const idempotencyKey = crypto.randomUUID();

  // Check idempotency — prevent double charges
  const existingKey = await redis.get(RedisKeys.idempotency(`${orderId}:${method}`));
  if (existingKey) {
    const existingPayment = await prisma.payment.findUnique({
      where: { idempotencyKey: existingKey },
    });
    if (existingPayment) {
      return {
        success: true,
        paymentId: existingPayment.id,
        status: existingPayment.status,
        message: "Payment already processed (idempotent)",
      };
    }
  }

  // Create payment record
  const payment = await prisma.payment.create({
    data: {
      orderId,
      userId,
      method,
      status: PaymentStatus.processing,
      amount,
      currency: "INR",
      idempotencyKey,
    },
  });

  // Store idempotency key (24h TTL)
  await redis.set(
    RedisKeys.idempotency(`${orderId}:${method}`),
    idempotencyKey,
    "EX",
    86400,
  );

  // Process based on method
  try {
    switch (method) {
      case PaymentMethod.wallet:
        await processWalletPayment(payment.id, userId, amount, pin);
        break;
      case PaymentMethod.stripe:
        await processStripePayment(payment.id, amount);
        break;
      case PaymentMethod.razorpay:
        await processRazorpayPayment(payment.id, amount);
        break;
      case PaymentMethod.upi:
        await processUpiPayment(payment.id, amount);
        break;
      case PaymentMethod.cash:
        await processCashPayment(payment.id);
        break;
    }

    return {
      success: true,
      paymentId: payment.id,
      status: "success",
      message: "Payment completed successfully",
    };
  } catch (err) {
    await prisma.payment.update({
      where: { id: payment.id },
      data: {
        status: PaymentStatus.failed,
        failureReason: err instanceof Error ? err.message : "Unknown error",
      },
    });

    logger.error({ msg: "Payment failed", paymentId: payment.id, error: err });

    return {
      success: false,
      paymentId: payment.id,
      status: "failed",
      message: err instanceof Error ? err.message : "Payment failed",
    };
  }
}

async function processWalletPayment(
  paymentId: string,
  userId: string,
  amount: number,
  pin?: string,
): Promise<void> {
  // PIN verification for amounts above ₹2000
  if (amount >= 2000) {
    if (!pin) throw new Error("PIN required for payments above ₹2000");
    const isValid = await verifyUserPin(userId, pin);
    if (!isValid) throw new Error("Invalid PIN");
  }

  const payment = await prisma.payment.findUnique({ where: { id: paymentId } });
  if (!payment) throw new Error("Payment not found");

  const result = await debitWallet(
    userId,
    amount,
    `Payment for order ${payment.orderId}`,
    paymentId,
  );

  await prisma.payment.update({
    where: { id: paymentId },
    data: {
      status: PaymentStatus.success,
      gatewayTxnId: result.transactionId,
      completedAt: new Date(),
    },
  });

  // Update order status
  await prisma.order.update({
    where: { id: payment.orderId },
    data: { status: "confirmed" },
  });
}

async function processStripePayment(paymentId: string, amount: number): Promise<void> {
  // STUB — Phase 7+: Real Stripe integration
  // const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);
  // const intent = await stripe.paymentIntents.create({ amount: amount * 100, currency: 'inr' });

  logger.info({ msg: "Stripe payment stub", paymentId, amount });

  await prisma.payment.update({
    where: { id: paymentId },
    data: {
      status: PaymentStatus.success,
      gatewayTxnId: `stripe_stub_${crypto.randomUUID().slice(0, 8)}`,
      completedAt: new Date(),
      gatewayResponse: { provider: "stripe", mode: "stub" },
    },
  });
}

async function processRazorpayPayment(paymentId: string, amount: number): Promise<void> {
  // STUB — Phase 7+: Real Razorpay integration
  logger.info({ msg: "Razorpay payment stub", paymentId, amount });

  await prisma.payment.update({
    where: { id: paymentId },
    data: {
      status: PaymentStatus.success,
      gatewayTxnId: `rzp_stub_${crypto.randomUUID().slice(0, 8)}`,
      completedAt: new Date(),
      gatewayResponse: { provider: "razorpay", mode: "stub" },
    },
  });
}

async function processUpiPayment(paymentId: string, amount: number): Promise<void> {
  // STUB — Phase 7+: Real UPI integration
  logger.info({ msg: "UPI payment stub", paymentId, amount });

  await prisma.payment.update({
    where: { id: paymentId },
    data: {
      status: PaymentStatus.success,
      gatewayTxnId: `upi_stub_${crypto.randomUUID().slice(0, 8)}`,
      completedAt: new Date(),
      gatewayResponse: { provider: "upi", mode: "stub" },
    },
  });
}

async function processCashPayment(paymentId: string): Promise<void> {
  // Cash on delivery — mark as pending until driver confirms
  await prisma.payment.update({
    where: { id: paymentId },
    data: {
      status: PaymentStatus.pending,
      gatewayTxnId: `cash_${crypto.randomUUID().slice(0, 8)}`,
      gatewayResponse: { provider: "cash", mode: "cod" },
    },
  });
}
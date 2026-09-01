import { Router, Request, Response } from "express";
import { z } from "zod";
import prisma from "../../config/database.js";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { authenticate } from "../../middleware/auth.js";
import { validateBody } from "../../middleware/validation.js";
import { BaseController } from "../../controllers/baseController.js";
import { Errors } from "../../middleware/errorHandler.js";
import { initiatePayment } from "../../services/paymentService.js";
import { PaymentMethod } from "../../generated/prisma/client.js";
import { paymentRateLimit } from "../../middleware/rateLimit.js";

const router = Router();

const paySchema = z.object({
  orderId: z.string().uuid(),
  method: z.nativeEnum(PaymentMethod),
  pin: z.string().regex(/^\d{6}$/).optional(),
});

// POST /payments/pay
router.post(
  "/pay",
  authenticate,
  paymentRateLimit,
  validateBody(paySchema),
  asyncHandler(async (req: Request, res: Response) => {
    const { orderId, method, pin } = req.body;

    // Verify order belongs to user
    const order = await prisma.order.findFirst({
      where: { id: orderId, userId: req.user!.sub },
    });
    if (!order) throw Errors.notFound("Order");

    const result = await initiatePayment({
      orderId,
      userId: req.user!.sub,
      method,
      amount: order.totalAmount,
      pin,
    });

    if (result.success) {
      BaseController.success(res, result);
    } else {
      throw Errors.badRequest(result.message);
    }
  }),
);

// GET /payments/order/:orderId
router.get(
  "/order/:orderId",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const payments = await prisma.payment.findMany({
      where: { orderId: req.params.orderId, userId: req.user!.sub },
      orderBy: { initiatedAt: "desc" },
    });
    BaseController.success(res, payments);
  }),
);

export default router;
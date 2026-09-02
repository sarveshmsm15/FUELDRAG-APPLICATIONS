import { Router, Request, Response } from "express";
import { z } from "zod";
import prisma from "../../config/database.js";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { authenticate } from "../../middleware/auth.js";
import { validateBody } from "../../middleware/validation.js";
import { BaseController } from "../../controllers/baseController.js";
import { Errors } from "../../middleware/errorHandler.js";
import { buildOffsetPagination, offsetPaginationSchema } from "../../utils/pagination.js";
import { calculatePricing, lockPrice } from "../../services/pricingService.js";
import { FuelType, OrderStatus } from "../../generated/prisma/client.js";

const router = Router();

const createOrderSchema = z.object({
  addressId: z.string().optional(),
  vehicleId: z.string().uuid().optional(),
  fuelType: z.nativeEnum(FuelType),
  quantityLiters: z.number().min(1).max(100),
  distanceKm: z.number().min(0).max(100).default(5),
  promoCode: z.string().optional(),
  notes: z.string().max(500).optional(),
});

// POST /orders — create order
router.post(
  "/",
  authenticate,
  validateBody(createOrderSchema),
  asyncHandler(async (req: Request, res: Response) => {
    const userId = req.user!.sub;
    const { addressId, vehicleId, fuelType, quantityLiters, distanceKm, promoCode, notes } = req.body;

    // Verify address belongs to user
    const address = await prisma.address.findFirst({
      where: { id: addressId, userId },
    });
    if (!address) throw Errors.notFound("Address");

    // Calculate pricing
    const pricing = await calculatePricing({ fuelType, quantityLiters, distanceKm, promoCode });

    // Create order
    const order = await prisma.order.create({
      data: {
        userId,
        addressId,
        vehicleId,
        fuelType,
        quantityLiters,
        status: OrderStatus.pending,
        subtotal: pricing.basePrice * pricing.surgeMultiplier,
        deliveryFee: pricing.deliveryFee,
        taxAmount: pricing.taxAmount,
        discountAmount: pricing.discountAmount,
        totalAmount: pricing.totalAmount,
        promoCode: promoCode?.toUpperCase(),
        notes,
        estimatedArrival: new Date(Date.now() + 30 * 60 * 1000), // 30 min ETA
      },
    });

    // Lock price
    await lockPrice(order.id, pricing, fuelType, quantityLiters);

    // Increment promo usage
    if (promoCode) {
      await prisma.promoCode.updateMany({
        where: { code: promoCode.toUpperCase() },
        data: { usageCount: { increment: 1 } },
      });
    }

    BaseController.created(res, {
      ...order,
      pricing,
    });
  }),
);

// GET /orders — user's orders
router.get(
  "/",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const params = offsetPaginationSchema.parse(req.query);
    const skip = (params.page - 1) * params.pageSize;
    const status = req.query.status as string | undefined;

    const where: Record<string, unknown> = { userId: req.user!.sub };
    if (status) where.status = status;

    const [orders, total] = await Promise.all([
      prisma.order.findMany({
        where,
        orderBy: { createdAt: "desc" },
        skip,
        take: params.pageSize,
        include: { address: true, vehicle: true },
      }),
      prisma.order.count({ where }),
    ]);

    BaseController.paginated(res, orders, {
      page: params.page,
      pageSize: params.pageSize,
      total,
      totalPages: Math.ceil(total / params.pageSize),
    });
  }),
);

// GET /orders/active — current active order
router.get(
  "/active",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const order = await prisma.order.findFirst({
      where: {
        userId: req.user!.sub,
        status: { notIn: [OrderStatus.completed, OrderStatus.cancelled, OrderStatus.failed] },
      },
      orderBy: { createdAt: "desc" },
      include: { address: true, driver: true, pricingSnapshot: true },
    });

    BaseController.success(res, order);
  }),
);

// GET /orders/:id
router.get(
  "/:id",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const order = await prisma.order.findFirst({
      where: { id: req.params.id, userId: req.user!.sub },
      include: { address: true, vehicle: true, driver: true, pricingSnapshot: true, payments: true },
    });
    if (!order) throw Errors.notFound("Order");
    BaseController.success(res, order);
  }),
);

// PATCH /orders/:id/cancel
router.patch(
  "/:id/cancel",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const order = await prisma.order.findFirst({
      where: { id: req.params.id, userId: req.user!.sub },
    });
    if (!order) throw Errors.notFound("Order");

    if (![OrderStatus.pending, OrderStatus.confirmed].includes(order.status)) {
      throw Errors.badRequest("Can only cancel pending or confirmed orders");
    }

    const updated = await prisma.order.update({
      where: { id: order.id },
      data: {
        status: OrderStatus.cancelled,
        cancelledAt: new Date(),
        cancelReason: (req.body.reason as string) ?? "User cancelled",
      },
    });

    BaseController.success(res, updated);
  }),
);

export default router;
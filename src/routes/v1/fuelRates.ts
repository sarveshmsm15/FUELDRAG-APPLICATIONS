import { Router, Request, Response } from "express";
import { z } from "zod";
import prisma from "../../config/database.js";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { authenticate } from "../../middleware/auth.js";
import { requireAdmin } from "../../middleware/requireRole.js";
import { validateBody } from "../../middleware/validation.js";
import { BaseController } from "../../controllers/baseController.js";
import { Errors } from "../../middleware/errorHandler.js";
import { buildOffsetPagination, offsetPaginationSchema } from "../../utils/pagination.js";
import { FuelType } from "../../generated/prisma/client.js";
import redis, { RedisKeys } from "../../config/redis.js";

const router = Router();

const updateRateSchema = z.object({
  fuelType: z.nativeEnum(FuelType),
  pricePerLiter: z.number().positive(),
  region: z.string().default("default"),
});

// GET /fuel-rates/current — public, cached
router.get(
  "/current",
  asyncHandler(async (_req: Request, res: Response) => {
    const cacheKey = "fuelrates:current:all";
    const cached = await redis.get(cacheKey);

    if (cached) {
      return BaseController.success(res, JSON.parse(cached));
    }

    const rates = await prisma.fuelRate.findMany({
      where: { isActive: true },
      orderBy: { fuelType: "asc" },
    });

    await redis.set(cacheKey, JSON.stringify(rates), "EX", 300); // 5 min cache
    BaseController.success(res, rates);
  }),
);

// GET /fuel-rates — admin only, paginated
router.get(
  "/",
  authenticate,
  requireAdmin,
  asyncHandler(async (req: Request, res: Response) => {
    const params = offsetPaginationSchema.parse(req.query);
    const skip = (params.page - 1) * params.pageSize;

    const [rates, total] = await Promise.all([
      prisma.fuelRate.findMany({
        orderBy: { createdAt: "desc" },
        skip,
        take: params.pageSize,
      }),
      prisma.fuelRate.count(),
    ]);

    BaseController.paginated(res, rates, {
      page: params.page,
      pageSize: params.pageSize,
      total,
      totalPages: Math.ceil(total / params.pageSize),
    });
  }),
);

// PUT /fuel-rates — admin only, update rate
router.put(
  "/",
  authenticate,
  requireAdmin,
  validateBody(updateRateSchema),
  asyncHandler(async (req: Request, res: Response) => {
    const { fuelType, pricePerLiter, region } = req.body;

    // Deactivate old rate
    await prisma.fuelRate.updateMany({
      where: { fuelType, region, isActive: true },
      data: { isActive: false, effectiveTo: new Date() },
    });

    // Create new rate
    const rate = await prisma.fuelRate.create({
      data: { fuelType, pricePerLiter, region, isActive: true },
    });

    // Save to history
    await prisma.fuelRateHistory.create({
      data: { fuelType, pricePerLiter, region },
    });

    // Invalidate cache
    await redis.del("fuelrates:current:all");

    BaseController.success(res, rate);
  }),
);

export default router;
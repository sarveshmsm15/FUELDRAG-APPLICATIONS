import { Router, Request, Response } from "express";
import { z } from "zod";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { authenticate } from "../../middleware/auth.js";
import { validateBody } from "../../middleware/validation.js";
import { BaseController } from "../../controllers/baseController.js";
import { calculatePricing } from "../../services/pricingService.js";
import { FuelType } from "../../generated/prisma/client.js";

const router = Router();

const pricingSchema = z.object({
  fuelType: z.nativeEnum(FuelType),
  quantityLiters: z.number().min(1).max(100),
  distanceKm: z.number().min(0).max(100),
  promoCode: z.string().optional(),
});

// POST /pricing/calculate
router.post(
  "/calculate",
  authenticate,
  validateBody(pricingSchema),
  asyncHandler(async (req: Request, res: Response) => {
    const pricing = await calculatePricing(req.body);
    BaseController.success(res, pricing);
  }),
);

export default router;
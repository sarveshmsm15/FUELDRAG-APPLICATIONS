import { Router, Request, Response } from "express";
import { z } from "zod";
import prisma from "../../config/database.js";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { authenticate } from "../../middleware/auth.js";
import { validateBody } from "../../middleware/validation.js";
import { BaseController } from "../../controllers/baseController.js";
import { Errors } from "../../middleware/errorHandler.js";
import { FuelType } from "../../generated/prisma/client.js";

const router = Router();

const vehicleSchema = z.object({
  registrationNumber: z.string().regex(/^[A-Z]{2}\d{1,2}[A-Z]{1,3}\d{4}$/i, "Invalid registration"),
  make: z.string().min(1),
  model: z.string().min(1),
  year: z.number().int().min(1990).max(2030).optional(),
  fuelType: z.nativeEnum(FuelType),
  tankCapacityLiters: z.number().positive().optional(),
  color: z.string().optional(),
  isDefault: z.boolean().default(false),
});

// GET /vehicles
router.get(
  "/",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const vehicles = await prisma.vehicle.findMany({
      where: { userId: req.user!.sub },
      orderBy: { isDefault: "desc" },
    });
    BaseController.success(res, vehicles);
  }),
);

// POST /vehicles
router.post(
  "/",
  authenticate,
  validateBody(vehicleSchema),
  asyncHandler(async (req: Request, res: Response) => {
    const { isDefault, ...data } = req.body;

    if (isDefault) {
      await prisma.vehicle.updateMany({
        where: { userId: req.user!.sub, isDefault: true },
        data: { isDefault: false },
      });
    }

    const vehicle = await prisma.vehicle.create({
      data: {
        ...data,
        isDefault,
        userId: req.user!.sub,
        registrationNumber: data.registrationNumber.toUpperCase(),
      },
    });

    BaseController.created(res, vehicle);
  }),
);

// DELETE /vehicles/:id
router.delete(
  "/:id",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const existing = await prisma.vehicle.findFirst({
      where: { id: req.params.id, userId: req.user!.sub },
    });
    if (!existing) throw Errors.notFound("Vehicle");

    await prisma.vehicle.delete({ where: { id: req.params.id } });
    BaseController.noContent(res);
  }),
);

export default router;
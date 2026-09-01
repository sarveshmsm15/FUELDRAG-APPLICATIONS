import { Router, Request, Response } from "express";
import { z } from "zod";
import prisma from "../../config/database.js";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { authenticate } from "../../middleware/auth.js";
import { validateBody } from "../../middleware/validation.js";
import { BaseController } from "../../controllers/baseController.js";
import { Errors } from "../../middleware/errorHandler.js";

const router = Router();

const addressSchema = z.object({
  label: z.string().min(1).max(50),
  line1: z.string().min(1),
  line2: z.string().optional(),
  city: z.string().min(1),
  state: z.string().min(1),
  pincode: z.string().regex(/^\d{6}$/, "Invalid pincode"),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  isDefault: z.boolean().default(false),
});

// GET /addresses
router.get(
  "/",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const addresses = await prisma.address.findMany({
      where: { userId: req.user!.sub },
      orderBy: { isDefault: "desc" },
    });
    BaseController.success(res, addresses);
  }),
);

// POST /addresses
router.post(
  "/",
  authenticate,
  validateBody(addressSchema),
  asyncHandler(async (req: Request, res: Response) => {
    const { isDefault, ...data } = req.body;

    if (isDefault) {
      await prisma.address.updateMany({
        where: { userId: req.user!.sub, isDefault: true },
        data: { isDefault: false },
      });
    }

    const address = await prisma.address.create({
      data: { ...data, isDefault, userId: req.user!.sub },
    });

    BaseController.created(res, address);
  }),
);

// PUT /addresses/:id
router.put(
  "/:id",
  authenticate,
  validateBody(addressSchema),
  asyncHandler(async (req: Request, res: Response) => {
    const existing = await prisma.address.findFirst({
      where: { id: req.params.id, userId: req.user!.sub },
    });
    if (!existing) throw Errors.notFound("Address");

    const { isDefault, ...data } = req.body;

    if (isDefault) {
      await prisma.address.updateMany({
        where: { userId: req.user!.sub, isDefault: true },
        data: { isDefault: false },
      });
    }

    const address = await prisma.address.update({
      where: { id: req.params.id },
      data: { ...data, isDefault },
    });

    BaseController.success(res, address);
  }),
);

// DELETE /addresses/:id
router.delete(
  "/:id",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const existing = await prisma.address.findFirst({
      where: { id: req.params.id, userId: req.user!.sub },
    });
    if (!existing) throw Errors.notFound("Address");

    await prisma.address.delete({ where: { id: req.params.id } });
    BaseController.noContent(res);
  }),
);

export default router;
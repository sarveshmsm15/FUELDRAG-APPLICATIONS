import { Router, Request, Response } from 'express';
import { z } from 'zod';
import prisma from '../../config/database.js';
import { authenticate } from '../../middleware/auth.js';
import { validateBody } from '../../middleware/validation.js';
import { asyncHandler } from '../../utils/asyncHandler.js';

const router = Router();

const addressSchema = z.object({
  label: z.string().default('Home'),
  line1: z.string().min(1).max(200),
  line2: z.string().max(200).optional().nullable().nullable(),
  city: z.string().min(1).max(100),
  state: z.string().min(1).max(100).default('Tamil Nadu'),
  pincode: z.string().min(4).max(10),
  latitude: z.number().default(13.0827),
  longitude: z.number().default(80.2707),
  isDefault: z.boolean().default(false),
}).passthrough();

// GET /addresses
router.get('/', authenticate, asyncHandler(async (req: Request, res: Response) => {
  const addresses = await prisma.address.findMany({
    where: { userId: req.user!.id },
    orderBy: [{ isDefault: 'desc' }, { createdAt: 'desc' }],
  });
  res.json({ success: true, data: addresses });
}));

// POST /addresses
router.post('/', authenticate, asyncHandler(async (req: Request, res: Response) => {
  const { isDefault, ...data } = req.body;
  if (isDefault) {
    await prisma.address.updateMany({
      where: { userId: req.user!.id, isDefault: true },
      data: { isDefault: false },
    });
  }
  console.log('Address create data:', JSON.stringify(data));
  const address = await prisma.address.create({
    data: { ...data, userId: req.user!.id, isDefault: isDefault ?? false },
  });
  res.status(201).json({ success: true, data: address });
}));

// PUT /addresses/:id
router.put('/:id', authenticate, asyncHandler(async (req: Request, res: Response) => {
  const { isDefault, ...data } = req.body;
  if (isDefault) {
    await prisma.address.updateMany({
      where: { userId: req.user!.id, isDefault: true },
      data: { isDefault: false },
    });
  }
  const address = await prisma.address.update({
    where: { id: req.params.id, userId: req.user!.id },
    data: { ...data, isDefault: isDefault ?? false },
  });
  res.json({ success: true, data: address });
}));

// DELETE /addresses/:id
router.delete('/:id', authenticate, asyncHandler(async (req: Request, res: Response) => {
  await prisma.address.delete({ where: { id: req.params.id, userId: req.user!.id } });
  res.json({ success: true, message: 'Address deleted' });
}));

export default router;

import { Router, Request, Response } from "express";
import { z } from "zod";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { authenticate } from "../../middleware/auth.js";
import { validateBody } from "../../middleware/validation.js";
import { BaseController } from "../../controllers/baseController.js";
import { getWallet, creditWallet } from "../../services/walletService.js";

const router = Router();

const addMoneySchema = z.object({
  amount: z.number().positive().max(50000),
});

// GET /wallet
router.get(
  "/",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const wallet = await getWallet(req.user!.sub);
    BaseController.success(res, wallet);
  }),
);

// POST /wallet/add-money — simulate adding money (dev only)
router.post(
  "/add-money",
  authenticate,
  validateBody(addMoneySchema),
  asyncHandler(async (req: Request, res: Response) => {
    const result = await creditWallet(
      req.user!.sub,
      req.body.amount,
      "Wallet top-up",
    );
    BaseController.success(res, result);
  }),
);

export default router;
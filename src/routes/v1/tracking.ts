import { Router, Request, Response } from "express";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { authenticate } from "../../middleware/auth.js";
import { BaseController } from "../../controllers/baseController.js";
import { Errors } from "../../middleware/errorHandler.js";
import { simulateDriverMovement, broadcastOrderStatus, sendNotification } from "../../services/trackingService.js";
import prisma from "../../config/database.js";

const router = Router();

// POST /tracking/simulate/:orderId — trigger driver simulation (dev only)
router.post(
  "/simulate/:orderId",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const order = await prisma.order.findFirst({
      where: { id: req.params.orderId, userId: req.user!.sub },
    });
    if (!order) throw Errors.notFound("Order");

    // Update order status to confirmed
    await prisma.order.update({
      where: { id: order.id },
      data: { status: "confirmed" },
    });

    await broadcastOrderStatus(order.id, req.user!.sub, "confirmed", {
      message: "Order confirmed! Driver assigned.",
    });

    sendNotification(req.user!.sub, "Order Confirmed ✅", "Your fuel order is confirmed. Driver is on the way!");

    // Start simulation in background
    simulateDriverMovement(order.id).catch((err) => {
      console.error("Simulation error:", err);
    });

    BaseController.accepted(res, { orderId: order.id }, "Driver simulation started");
  }),
);

// GET /tracking/order/:orderId — get current tracking state
router.get(
  "/order/:orderId",
  authenticate,
  asyncHandler(async (req: Request, res: Response) => {
    const order = await prisma.order.findFirst({
      where: { id: req.params.orderId, userId: req.user!.sub },
      include: { address: true, driver: true },
    });
    if (!order) throw Errors.notFound("Order");

    BaseController.success(res, {
      orderId: order.id,
      status: order.status,
      estimatedArrival: order.estimatedArrival,
      address: order.address,
      driver: order.driver,
    });
  }),
);

export default router;
import { Router } from "express";
import healthRouter from "./v1/health.js";
import authRouter from "./v1/auth.js";
import fuelRateRouter from "./v1/fuelRates.js";
import addressRouter from "./v1/addresses.js";
import vehicleRouter from "./v1/vehicles.js";
import pricingRouter from "./v1/pricing.js";
import orderRouter from "./v1/orders.js";
import walletRouter from "./v1/wallet.js";
import paymentRouter from "./v1/payments.js";
import trackingRouter from "./v1/tracking.js";
import adminRouter from "./v1/admin.js";

const router = Router();

router.use("/health", healthRouter);
router.use("/auth", authRouter);
router.use("/fuel-rates", fuelRateRouter);
router.use("/addresses", addressRouter);
router.use("/vehicles", vehicleRouter);
router.use("/pricing", pricingRouter);
router.use("/orders", orderRouter);
router.use("/wallet", walletRouter);
router.use("/payments", paymentRouter);
router.use("/tracking", trackingRouter);
router.use("/admin", adminRouter);

export default router;
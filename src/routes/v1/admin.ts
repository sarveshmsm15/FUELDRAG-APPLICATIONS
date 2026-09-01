import { Router, Request, Response } from "express";
import prisma from "../../config/database.js";
import { asyncHandler } from "../../utils/asyncHandler.js";
import { authenticate } from "../../middleware/auth.js";
import { requireAdmin } from "../../middleware/requireRole.js";
import { BaseController } from "../../controllers/baseController.js";
import { Errors } from "../../middleware/errorHandler.js";
import { broadcastOrderStatus, sendNotification } from "../../services/trackingService.js";
import { buildOffsetPagination, offsetPaginationSchema } from "../../utils/pagination.js";

const router = Router();

// All admin routes require authentication + admin role
router.use(authenticate, requireAdmin);

// GET /admin/dashboard — overview stats
router.get(
  "/dashboard",
  asyncHandler(async (_req: Request, res: Response) => {
    const now = new Date();
    const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

    const [
      totalUsers,
      totalOrders,
      todayOrders,
      weekOrders,
      activeOrders,
      totalRevenue,
      todayRevenue,
      weekRevenue,
      totalDrivers,
      activeDrivers,
    ] = await Promise.all([
      prisma.user.count({ where: { role: "customer" } }),
      prisma.order.count(),
      prisma.order.count({ where: { createdAt: { gte: todayStart } } }),
      prisma.order.count({ where: { createdAt: { gte: weekAgo } } }),
      prisma.order.count({ where: { status: { notIn: ["completed", "cancelled", "failed"] } } }),
      prisma.order.aggregate({ _sum: { totalAmount: true }, where: { status: "completed" } }),
      prisma.order.aggregate({ _sum: { totalAmount: true }, where: { status: "completed", createdAt: { gte: todayStart } } }),
      prisma.order.aggregate({ _sum: { totalAmount: true }, where: { status: "completed", createdAt: { gte: weekAgo } } }),
      prisma.user.count({ where: { role: "driver" } }),
      prisma.user.count({ where: { role: "driver", isActive: true } }),
    ]);

    BaseController.success(res, {
      users: { total: totalUsers },
      orders: { total: totalOrders, today: todayOrders, week: weekOrders, active: activeOrders },
      revenue: {
        total: totalRevenue._sum.totalAmount ?? 0,
        today: todayRevenue._sum.totalAmount ?? 0,
        week: weekRevenue._sum.totalAmount ?? 0,
      },
      drivers: { total: totalDrivers, active: activeDrivers },
    });
  }),
);

// GET /admin/orders — all orders (paginated, filterable)
router.get(
  "/orders",
  asyncHandler(async (req: Request, res: Response) => {
    const params = offsetPaginationSchema.parse(req.query);
    const skip = (params.page - 1) * params.pageSize;
    const status = req.query.status as string | undefined;
    const search = req.query.search as string | undefined;

    const where: Record<string, unknown> = {};
    if (status) where.status = status;
    if (search) {
      where.OR = [
        { id: { contains: search } },
        { user: { phone: { contains: search } } },
      ];
    }

    const [orders, total] = await Promise.all([
      prisma.order.findMany({
        where,
        orderBy: { createdAt: "desc" },
        skip,
        take: params.pageSize,
        include: { user: { select: { name: true, phone: true } }, address: true, driver: { select: { name: true, phone: true } } },
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

// PATCH /admin/orders/:id/assign — assign driver to order
router.patch(
  "/orders/:id/assign",
  asyncHandler(async (req: Request, res: Response) => {
    const { driverId } = req.body;
    if (!driverId) throw Errors.badRequest("driverId is required");

    const order = await prisma.order.findUnique({ where: { id: req.params.id } });
    if (!order) throw Errors.notFound("Order");

    const driver = await prisma.user.findFirst({ where: { id: driverId, role: "driver" } });
    if (!driver) throw Errors.notFound("Driver");

    const updated = await prisma.order.update({
      where: { id: order.id },
      data: { driverId, status: "confirmed" },
    });

    await broadcastOrderStatus(order.id, order.userId, "confirmed", {
      driverName: driver.name,
      driverPhone: driver.phone,
    });

    sendNotification(order.userId, "Driver Assigned 🚗", `${driver.name} is on the way to deliver your fuel!`);

    BaseController.success(res, updated);
  }),
);

// PATCH /admin/orders/:id/status — update order status
router.patch(
  "/orders/:id/status",
  asyncHandler(async (req: Request, res: Response) => {
    const { status } = req.body;
    if (!status) throw Errors.badRequest("status is required");

    const order = await prisma.order.findUnique({ where: { id: req.params.id } });
    if (!order) throw Errors.notFound("Order");

    const updated = await prisma.order.update({
      where: { id: order.id },
      data: { status },
    });

    await broadcastOrderStatus(order.id, order.userId, status);

    BaseController.success(res, updated);
  }),
);

// GET /admin/drivers — list all drivers
router.get(
  "/drivers",
  asyncHandler(async (req: Request, res: Response) => {
    const params = offsetPaginationSchema.parse(req.query);
    const skip = (params.page - 1) * params.pageSize;

    const [drivers, total] = await Promise.all([
      prisma.user.findMany({
        where: { role: "driver" },
        orderBy: { createdAt: "desc" },
        skip,
        take: params.pageSize,
        select: { id: true, name: true, phone: true, email: true, isActive: true, isVerified: true, lastLoginAt: true, createdAt: true },
      }),
      prisma.user.count({ where: { role: "driver" } }),
    ]);

    BaseController.paginated(res, drivers, {
      page: params.page,
      pageSize: params.pageSize,
      total,
      totalPages: Math.ceil(total / params.pageSize),
    });
  }),
);

// GET /admin/analytics/revenue — daily revenue for last 30 days
router.get(
  "/analytics/revenue",
  asyncHandler(async (_req: Request, res: Response) => {
    const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);

    const orders = await prisma.order.findMany({
      where: { status: "completed", createdAt: { gte: thirtyDaysAgo } },
      select: { totalAmount: true, createdAt: true },
      orderBy: { createdAt: "asc" },
    });

    // Group by day
    const dailyMap = new Map<string, number>();
    for (const order of orders) {
      const day = order.createdAt.toISOString().split("T")[0];
      dailyMap.set(day, (dailyMap.get(day) ?? 0) + order.totalAmount);
    }

    const dailyRevenue = Array.from(dailyMap.entries()).map(([date, revenue]) => ({
      date,
      revenue: Math.round(revenue * 100) / 100,
    }));

    BaseController.success(res, dailyRevenue);
  }),
);

// GET /admin/analytics/orders-by-status — order count by status
router.get(
  "/analytics/orders-by-status",
  asyncHandler(async (_req: Request, res: Response) => {
    const statuses = await prisma.order.groupBy({
      by: ["status"],
      _count: { id: true },
    });

    BaseController.success(res, statuses.map((s) => ({ status: s.status, count: s._count.id })));
  }),
);

export default router;
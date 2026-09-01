import { Server as SocketIOServer } from "socket.io";
import prisma from "../config/database.js";
import { logger } from "../logging/logger.js";

let io: SocketIOServer;

export function setSocketServer(socketIo: SocketIOServer): void {
  io = socketIo;
}


export function broadcastDriverLocation(
  orderId: string,
  driverId: string,
  latitude: number,
  longitude: number,
): void {
  if (!io) return;

  io.to(`order:${orderId}`).emit("driver:locationUpdate", {
    orderId,
    driverId,
    latitude,
    longitude,
    timestamp: new Date().toISOString(),
  });
}

/**
 * Broadcast order status change.
 */
export async function broadcastOrderStatus(
  orderId: string,
  userId: string,
  status: string,
  details?: Record<string, unknown>,
): Promise<void> {
  if (!io) return;

  const payload = {
    orderId,
    status,
    details,
    timestamp: new Date().toISOString(),
  };

  // Send to the order owner
  io.to(`user:${userId}`).emit("order:statusUpdate", payload);

  // Send to anyone tracking this order
  io.to(`order:${orderId}`).emit("order:statusUpdate", payload);

  logger.info({ msg: "Order status broadcast", orderId, userId, status });
}

/**
 * Send a targeted notification to a user.
 */
export function sendNotification(
  userId: string,
  title: string,
  body: string,
  data?: Record<string, unknown>,
): void {
  if (!io) return;

  io.to(`user:${userId}`).emit("notification:new", {
    id: crypto.randomUUID(),
    title,
    body,
    data,
    timestamp: new Date().toISOString(),
  });

  logger.info({ msg: "Notification sent", userId, title });
}

/**
 * Simulate driver movement for demo purposes.
 * Moves driver toward delivery address in steps.
 */
export async function simulateDriverMovement(orderId: string): Promise<void> {
  const order = await prisma.order.findUnique({
    where: { id: orderId },
    include: { address: true },
  });

  if (!order?.address) return;

  // Start position (random near the address)
  let lat = order.address.latitude + 0.02;
  let lng = order.address.longitude + 0.02;
  const targetLat = order.address.latitude;
  const targetLng = order.address.longitude;

  const steps = 20;
  const latStep = (targetLat - lat) / steps;
  const lngStep = (targetLng - lng) / steps;

  for (let i = 0; i < steps; i++) {
    await new Promise((resolve) => setTimeout(resolve, 3000)); // 3 sec intervals

    lat += latStep + (Math.random() - 0.5) * 0.001; // Add slight randomness
    lng += lngStep + (Math.random() - 0.5) * 0.001;

    broadcastDriverLocation(orderId, "driver-demo", lat, lng);

    if (i === 5) {
      await broadcastOrderStatus(orderId, order.userId, "driver_arriving", {
        etaMinutes: 5,
      });
      sendNotification(order.userId, "Driver Approaching", "Your driver is 5 minutes away!");
    }

    if (i === steps - 1) {
      await broadcastOrderStatus(orderId, order.userId, "delivered", {});
      sendNotification(order.userId, "Fuel Delivered! ⛽", "Your fuel has been delivered successfully!");
    }
  }
}
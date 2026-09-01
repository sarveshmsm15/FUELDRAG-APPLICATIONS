import { Server as SocketIOServer, Socket } from "socket.io";
import { verifyAccessToken } from "../security/jwt.js";
import { logger } from "../logging/logger.js";
import { activeConnections } from "../monitoring/metrics.js";

/**
 * Socket.io initialization with authentication middleware.
 * Only authenticated users can establish WebSocket connections.
 */
export function initializeSocket(io: SocketIOServer): void {
  // ── Authentication Middleware ──
  io.use((socket, next) => {
    const token = socket.handshake.auth?.token as string | undefined;

    if (!token) {
      logger.warn({ msg: "Socket connection rejected: no token", socketId: socket.id });
      return next(new Error("Authentication required"));
    }

    try {
      const payload = verifyAccessToken(token);
      // Attach user data to socket
      (socket as AuthenticatedSocket).userId = payload.sub;
      (socket as AuthenticatedSocket).userRole = payload.role;
      next();
    } catch (err) {
      logger.warn({
        msg: "Socket connection rejected: invalid token",
        socketId: socket.id,
        error: err instanceof Error ? err.message : "Unknown",
      });
      next(new Error("Invalid or expired token"));
    }
  });

  // ── Connection Handler ──
  io.on("connection", (socket: Socket) => {
    const authSocket = socket as AuthenticatedSocket;
    const userId = authSocket.userId ?? "unknown";

    logger.info({ msg: "Socket connected", socketId: socket.id, userId });
    activeConnections.inc({ type: "websocket" });

    // Join user-specific room for targeted notifications
    socket.join(`user:${userId}`);

    // ── Tracking Events ──
    socket.on("track:order", (orderId: string) => {
      socket.join(`order:${orderId}`);
      logger.debug({ msg: "User tracking order", userId, orderId });
    });

    socket.on("untrack:order", (orderId: string) => {
      socket.leave(`order:${orderId}`);
      logger.debug({ msg: "User stopped tracking order", userId, orderId });
    });

    // ── Driver Location Updates ──
    socket.on("driver:location", (data: { orderId: string; lat: number; lng: number }) => {
      // Broadcast to all clients tracking this order
      io.to(`order:${data.orderId}`).emit("driver:locationUpdate", {
        orderId: data.orderId,
        latitude: data.lat,
        longitude: data.lng,
        timestamp: new Date().toISOString(),
      });
    });

    // ── Chat ──
    socket.on("chat:join", (chatId: string) => {
      socket.join(`chat:${chatId}`);
    });

    socket.on("chat:message", (data: { chatId: string; message: string }) => {
      io.to(`chat:${data.chatId}`).emit("chat:newMessage", {
        chatId: data.chatId,
        senderId: userId,
        message: data.message,
        timestamp: new Date().toISOString(),
      });
    });

    // ── Disconnect ──
    socket.on("disconnect", (reason) => {
      logger.info({ msg: "Socket disconnected", socketId: socket.id, userId, reason });
      activeConnections.dec({ type: "websocket" });
    });
  });

  logger.info("🔌 Socket.io initialized with authentication");
}

/** Extended socket type with authenticated user data. */
export interface AuthenticatedSocket extends Socket {
  userId?: string;
  userRole?: string;
}

/** Helper: emit to a specific user. */
export function emitToUser(io: SocketIOServer, userId: string, event: string, data: unknown): void {
  io.to(`user:${userId}`).emit(event, data);
}

/** Helper: emit to all clients tracking an order. */
export function emitToOrder(io: SocketIOServer, orderId: string, event: string, data: unknown): void {
  io.to(`order:${orderId}`).emit(event, data);
}
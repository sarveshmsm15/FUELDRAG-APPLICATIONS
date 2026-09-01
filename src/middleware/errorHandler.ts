import { Request, Response, NextFunction } from "express";

/**
 * Structured error class for API errors.
 */
export class ApiError extends Error {
  constructor(
    public readonly statusCode: number,
    public readonly code: string,
    message: string,
    public readonly details?: unknown,
  ) {
    super(message);
    this.name = "ApiError";
  }
}

/** Common API errors. */
export const Errors = {
  badRequest: (message: string, details?: unknown) =>
    new ApiError(400, "BAD_REQUEST", message, details),
  unauthorized: (message = "Unauthorized") =>
    new ApiError(401, "UNAUTHORIZED", message),
  forbidden: (message = "Forbidden") =>
    new ApiError(403, "FORBIDDEN", message),
  notFound: (entity: string) =>
    new ApiError(404, "NOT_FOUND", `${entity} not found`),
  conflict: (message: string) =>
    new ApiError(409, "CONFLICT", message),
  tooManyRequests: (retryAfter: number) =>
    new ApiError(429, "TOO_MANY_REQUESTS", "Rate limit exceeded", { retryAfter }),
  internal: (message = "Internal server error") =>
    new ApiError(500, "INTERNAL_ERROR", message),
};

/**
 * Global error handler middleware.
 * Catches all errors and returns structured JSON responses.
 */
export function errorHandler(
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
): void {
  // Handle known API errors
  if (err instanceof ApiError) {
    res.status(err.statusCode).json({
      error: err.code,
      message: err.message,
      details: err.details,
      timestamp: new Date().toISOString(),
    });
    return;
  }

  // Handle Prisma errors
  if (err.name === "PrismaClientKnownRequestError") {
    const prismaErr = err as Error & { code: string };
    if (prismaErr.code === "P2002") {
      res.status(409).json({
        error: "CONFLICT",
        message: "A record with this value already exists",
        timestamp: new Date().toISOString(),
      });
      return;
    }
    if (prismaErr.code === "P2025") {
      res.status(404).json({
        error: "NOT_FOUND",
        message: "Record not found",
        timestamp: new Date().toISOString(),
      });
      return;
    }
  }

  // Handle JWT errors
  if (err.name === "JsonWebTokenError") {
    res.status(401).json({
      error: "AUTH_INVALID_TOKEN",
      message: "Invalid token",
      timestamp: new Date().toISOString(),
    });
    return;
  }

  if (err.name === "TokenExpiredError") {
    res.status(401).json({
      error: "AUTH_TOKEN_EXPIRED",
      message: "Token expired",
      timestamp: new Date().toISOString(),
    });
    return;
  }

  // Log unexpected errors
  console.error("Unhandled error:", {
    name: err.name,
    message: err.message,
    stack: err.stack,
  });

  // Generic 500 for unknown errors (don't leak internals)
  res.status(500).json({
    error: "INTERNAL_ERROR",
    message:
      process.env.NODE_ENV === "production"
        ? "Internal server error"
        : err.message,
    timestamp: new Date().toISOString(),
  });
}

/**
 * Async handler wrapper — catches promise rejections and passes to errorHandler.
 */
export function asyncHandler(
  fn: (req: Request, res: Response, next: NextFunction) => Promise<unknown>,
) {
  return (req: Request, res: Response, next: NextFunction): void => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}
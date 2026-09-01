/**
 * Structured API Error class.
 * Used throughout the application for consistent error handling.
 */
export class ApiError extends Error {
  public readonly statusCode: number;
  public readonly code: string;
  public readonly details: unknown;
  public readonly isOperational: boolean;

  constructor(
    statusCode: number,
    code: string,
    message: string,
    details?: unknown,
    isOperational = true,
  ) {
    super(message);
    this.statusCode = statusCode;
    this.code = code;
    this.details = details;
    this.isOperational = isOperational;
    this.name = "ApiError";

    // Capture proper stack trace
    Error.captureStackTrace(this, this.constructor);
  }

  toJSON(): Record<string, unknown> {
    return {
      error: this.code,
      message: this.message,
      details: this.details,
      timestamp: new Date().toISOString(),
    };
  }
}

// ── Factory Functions ──
export const badRequest = (message: string, details?: unknown) =>
  new ApiError(400, "BAD_REQUEST", message, details);

export const unauthorized = (message = "Unauthorized") =>
  new ApiError(401, "UNAUTHORIZED", message);

export const forbidden = (message = "Forbidden") =>
  new ApiError(403, "FORBIDDEN", message);

export const notFound = (entity: string) =>
  new ApiError(404, "NOT_FOUND", `${entity} not found`);

export const conflict = (message: string) =>
  new ApiError(409, "CONFLICT", message);

export const validationError = (message: string, details?: unknown) =>
  new ApiError(422, "VALIDATION_ERROR", message, details);

export const tooManyRequests = (retryAfter: number) =>
  new ApiError(429, "TOO_MANY_REQUESTS", "Rate limit exceeded", { retryAfter });

export const internalError = (message = "Internal server error") =>
  new ApiError(500, "INTERNAL_ERROR", message, undefined, false);

export const serviceUnavailable = (service: string) =>
  new ApiError(503, "SERVICE_UNAVAILABLE", `${service} is temporarily unavailable`);
import { Request, Response, NextFunction } from "express";
import { ZodSchema, ZodError } from "zod";

/**
 * Zod validation middleware for request body, query, or params.
 */
export function validate(schema: ZodSchema, source: "body" | "query" | "params" = "body") {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      const data = req[source];
      const parsed = schema.parse(data);
      // Replace with parsed (and potentially transformed) data
      (req as Record<string, unknown>)[source] = parsed;
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        res.status(400).json({
          error: "VALIDATION_ERROR",
          message: "Request validation failed",
          details: error.issues.map((issue) => ({
            field: issue.path.join("."),
            message: issue.message,
            code: issue.code,
          })),
          timestamp: new Date().toISOString(),
        });
        return;
      }
      next(error);
    }
  };
}

/** Validate request body. */
export function validateBody(schema: ZodSchema) {
  return validate(schema, "body");
}

/** Validate query parameters. */
export function validateQuery(schema: ZodSchema) {
  return validate(schema, "query");
}

/** Validate route parameters. */
export function validateParams(schema: ZodSchema) {
  return validate(schema, "params");
}
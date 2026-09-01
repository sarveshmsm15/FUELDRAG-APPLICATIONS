import { Response } from "express";


export class BaseController {
  /** Success response with data. */
  static success<T>(res: Response, data: T, statusCode = 200): void {
    res.status(statusCode).json({
      success: true,
      data,
      timestamp: new Date().toISOString(),
    });
  }

  /** Success response with pagination. */
  static paginated<T>(
    res: Response,
    data: T[],
    pagination: {
      page: number;
      pageSize: number;
      total: number;
      totalPages: number;
    },
  ): void {
    res.status(200).json({
      success: true,
      data,
      pagination,
      timestamp: new Date().toISOString(),
    });
  }

  /** Created response (201). */
  static created<T>(res: Response, data: T): void {
    res.status(201).json({
      success: true,
      data,
      timestamp: new Date().toISOString(),
    });
  }

  /** No content response (204). */
  static noContent(res: Response): void {
    res.status(204).send();
  }

  /** Accepted response (202) — for async operations. */
  static accepted<T>(res: Response, data: T, message = "Request accepted"): void {
    res.status(202).json({
      success: true,
      message,
      data,
      timestamp: new Date().toISOString(),
    });
  }
}
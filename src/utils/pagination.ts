import { z } from "zod";

/**
 * Pagination utilities for cursor-based and offset-based pagination.
 */

// ── Offset Pagination ──
export const offsetPaginationSchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(100).default(20),
});

export type OffsetPagination = z.infer<typeof offsetPaginationSchema>;

export interface PaginatedResult<T> {
  data: T[];
  pagination: {
    page: number;
    pageSize: number;
    total: number;
    totalPages: number;
    hasNextPage: boolean;
    hasPrevPage: boolean;
  };
}

export function buildOffsetPagination<T>(
  data: T[],
  total: number,
  params: OffsetPagination,
): PaginatedResult<T> {
  const { page, pageSize } = params;
  const totalPages = Math.ceil(total / pageSize);

  return {
    data,
    pagination: {
      page,
      pageSize,
      total,
      totalPages,
      hasNextPage: page < totalPages,
      hasPrevPage: page > 1,
    },
  };
}

// ── Cursor Pagination ──
export const cursorPaginationSchema = z.object({
  cursor: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});

export type CursorPagination = z.infer<typeof cursorPaginationSchema>;

export interface CursorPaginatedResult<T> {
  data: T[];
  pagination: {
    nextCursor: string | null;
    hasMore: boolean;
    limit: number;
  };
}

export function buildCursorPagination<T extends { id: string }>(
  data: T[],
  limit: number,
): CursorPaginatedResult<T> {
  const hasMore = data.length > limit;
  const trimmedData = hasMore ? data.slice(0, limit) : data;
  const nextCursor = hasMore && trimmedData.length > 0
    ? trimmedData[trimmedData.length - 1].id
    : null;

  return {
    data: trimmedData,
    pagination: {
      nextCursor,
      hasMore,
      limit,
    },
  };
}
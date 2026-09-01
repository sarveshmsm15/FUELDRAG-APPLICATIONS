import { Request, Response, NextFunction } from "express";

/**
 * Role-based access control middleware.
 * Must be used AFTER authenticate middleware.
 */
export function requireRole(...allowedRoles: string[]) {
  return (req: Request, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({
        error: "Unauthorized",
        message: "Authentication required",
        code: "AUTH_REQUIRED",
      });
      return;
    }

    if (!allowedRoles.includes(req.user.role)) {
      res.status(403).json({
        error: "Forbidden",
        message: `Role '${req.user.role}' is not authorized for this action`,
        code: "AUTH_INSUFFICIENT_ROLE",
      });
      return;
    }

    next();
  };
}

/** Convenience: require admin or super_admin. */
export const requireAdmin = requireRole("admin", "super_admin");

/** Convenience: require super_admin only. */
export const requireSuperAdmin = requireRole("super_admin");

/** Convenience: require driver role. */
export const requireDriver = requireRole("driver");

/** Convenience: require customer role. */
export const requireCustomer = requireRole("customer");
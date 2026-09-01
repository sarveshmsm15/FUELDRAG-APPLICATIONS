import pinoHttp from "pino-http";
import { logger } from "./logger.js";

/**
 * HTTP request logger using pino-http.
 */
export const requestLogger = pinoHttp({
  logger,
  autoLogging: {
    ignore: (req) => {
      return req.url === "/health" || req.url?.includes("/health/ping");
    },
  },
  customLogLevel: (_req, res, err) => {
    if (err || res.statusCode >= 500) return "error";
    if (res.statusCode >= 400) return "warn";
    return "info";
  },
  customSuccessMessage: (req, res) => {
    return `${req.method} ${req.url} ${res.statusCode}`;
  },
  customErrorMessage: (req, res, err) => {
    return `${req.method} ${req.url} ${res.statusCode} ${err.message}`;
  },
  serializers: {
    req: (req) => ({
      method: req.method,
      url: req.url,
      remoteAddress: req.remoteAddress,
    }),
    res: (res) => ({
      statusCode: res.statusCode,
    }),
  },
});
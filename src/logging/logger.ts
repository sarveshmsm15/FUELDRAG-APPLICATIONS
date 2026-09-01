import pino from "pino";

/**
 * Pino structured JSON logger for FUELRUSH.
 * - Production: JSON output for log aggregation
 * - Development: Pretty-printed colored output
 */
export const logger = pino({
  level: process.env.LOG_LEVEL ?? (process.env.NODE_ENV === "production" ? "info" : "debug"),
  transport:
    process.env.NODE_ENV !== "production"
      ? {
          target: "pino-pretty",
          options: {
            colorize: true,
            translateTime: "SYS:standard",
            ignore: "pid,hostname",
            messageFormat: "{msg}",
          },
        }
      : undefined,
  redact: {
    paths: [
      "req.headers.authorization",
      "req.headers.cookie",
      "req.body.password",
      "req.body.pin",
      "req.body.otp",
      "req.body.token",
      "req.body.refreshToken",
      "req.body.creditCard",
      "req.body.cvv",
      "*.password",
      "*.pin",
      "*.token",
      "*.secret",
      "*.creditCard",
    ],
    censor: "[REDACTED]",
  },
  serializers: {
    err: pino.stdSerializers.err,
    req: (req) => ({
      method: req.method,
      url: req.url,
      remoteAddress: req.remoteAddress,
    }),
    res: (res) => ({
      statusCode: res.statusCode,
    }),
  },
  base: {
    service: "fuelrush-api",
    version: process.env.APP_VERSION ?? "1.0.0",
  },
});

export default logger;
/**
 * Application configuration — centralized config object.
 * All values sourced from environment variables with safe defaults.
 */
export const config = {
  server: {
    port: parseInt(process.env.PORT ?? "3000", 10),
    env: process.env.NODE_ENV ?? "development",
    apiVersion: process.env.API_VERSION ?? "v1",
    appVersion: process.env.APP_VERSION ?? "1.0.0",
  },

  database: {
    url: process.env.DATABASE_URL ?? "",
  },

  redis: {
    url: process.env.REDIS_URL ?? "redis://localhost:6379",
  },

  jwt: {
    accessExpiry: process.env.JWT_ACCESS_EXPIRY ?? "15m",
    refreshExpiry: process.env.JWT_REFRESH_EXPIRY ?? "30d",
    privateKeyPath: process.env.JWT_PRIVATE_KEY_PATH ?? "./keys/jwt-private.pem",
    publicKeyPath: process.env.JWT_PUBLIC_KEY_PATH ?? "./keys/jwt-public.pem",
  },

  encryption: {
    key: process.env.ENCRYPTION_KEY ?? "",
  },

  otp: {
    expiryMinutes: parseInt(process.env.OTP_EXPIRY_MINUTES ?? "10", 10),
    maxAttemptsPerHour: parseInt(process.env.OTP_MAX_ATTEMPTS_PER_HOUR ?? "3", 10),
    length: 6,
  },

  rateLimit: {
    windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS ?? "60000", 10),
    maxRequests: parseInt(process.env.RATE_LIMIT_MAX_REQUESTS ?? "60", 10),
  },

  admin: {
    ipWhitelist: (process.env.ADMIN_IP_WHITELIST ?? "127.0.0.1,::1").split(","),
    sessionTimeoutMinutes: parseInt(process.env.ADMIN_SESSION_TIMEOUT_MINUTES ?? "30", 10),
  },

  stripe: {
    secretKey: process.env.STRIPE_SECRET_KEY ?? "",
    webhookSecret: process.env.STRIPE_WEBHOOK_SECRET ?? "",
  },

  razorpay: {
    keyId: process.env.RAZORPAY_KEY_ID ?? "",
    keySecret: process.env.RAZORPAY_KEY_SECRET ?? "",
    webhookSecret: process.env.RAZORPAY_WEBHOOK_SECRET ?? "",
  },

  googleMaps: {
    apiKey: process.env.GOOGLE_MAPS_API_KEY ?? "",
  },

  firebase: {
    projectId: process.env.FIREBASE_PROJECT_ID ?? "",
    clientEmail: process.env.FIREBASE_CLIENT_EMAIL ?? "",
    privateKey: process.env.FIREBASE_PRIVATE_KEY ?? "",
  },

  get isDevelopment(): boolean {
    return this.server.env === "development";
  },

  get isProduction(): boolean {
    return this.server.env === "production";
  },
} as const;
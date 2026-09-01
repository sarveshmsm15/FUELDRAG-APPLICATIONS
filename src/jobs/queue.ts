import { Queue, Worker, Job, QueueEvents } from "bullmq";
import { logger } from "../logging/logger.js";

const REDIS_URL = process.env.REDIS_URL ?? "redis://localhost:6379";

const connection = { url: REDIS_URL };

// ── Queue Definitions ──

/** OTP delivery queue. */
export const otpQueue = new Queue("otp-delivery", {
  connection,
  defaultJobOptions: {
    attempts: 3,
    backoff: { type: "exponential", delay: 1000 },
    removeOnComplete: { count: 100 },
    removeOnFail: { count: 50 },
  },
});

/** Notification delivery queue. */
export const notificationQueue = new Queue("notifications", {
  connection,
  defaultJobOptions: {
    attempts: 3,
    backoff: { type: "exponential", delay: 2000 },
    removeOnComplete: { count: 200 },
    removeOnFail: { count: 100 },
  },
});

/** Payment processing queue. */
export const paymentQueue = new Queue("payments", {
  connection,
  defaultJobOptions: {
    attempts: 3,
    backoff: { type: "exponential", delay: 5000 },
    removeOnComplete: { count: 500 },
    removeOnFail: { count: 200 },
  },
});

/** Fuel rate sync queue. */
export const fuelRateQueue = new Queue("fuel-rate-sync", {
  connection,
  defaultJobOptions: {
    attempts: 3,
    backoff: { type: "fixed", delay: 30000 },
    removeOnComplete: { count: 50 },
    removeOnFail: { count: 20 },
  },
});

/** Cleanup queue (expired sessions, old tracking data, etc.). */
export const cleanupQueue = new Queue("cleanup", {
  connection,
  defaultJobOptions: {
    attempts: 1,
    removeOnComplete: { count: 20 },
    removeOnFail: { count: 10 },
  },
});

// ── Queue Event Listeners ──
function setupQueueEvents(name: string, queue: Queue): void {
  const events = new QueueEvents(name, { connection });

  events.on("completed", ({ jobId }) => {
    logger.debug({ msg: `Job completed in ${name}`, jobId });
  });

  events.on("failed", ({ jobId, failedReason }) => {
    logger.error({ msg: `Job failed in ${name}`, jobId, failedReason });
  });

  events.on("stalled", ({ jobId }) => {
    logger.warn({ msg: `Job stalled in ${name}`, jobId });
  });
}

setupQueueEvents("otp-delivery", otpQueue);
setupQueueEvents("notifications", notificationQueue);
setupQueueEvents("payments", paymentQueue);
setupQueueEvents("fuel-rate-sync", fuelRateQueue);
setupQueueEvents("cleanup", cleanupQueue);

// ── Worker Registration Helper ──
export function createWorker<T = unknown>(
  name: string,
  processor: (job: Job<T>) => Promise<unknown>,
  concurrency = 5,
): Worker<T> {
  const worker = new Worker<T>(name, processor, {
    connection,
    concurrency,
    limiter: { max: 100, duration: 60000 }, // 100 jobs per minute max
  });

  worker.on("ready", () => {
    logger.info({ msg: `Worker ready: ${name}`, concurrency });
  });

  worker.on("error", (err) => {
    logger.error({ msg: `Worker error: ${name}`, error: err.message });
  });

  worker.on("failed", (job, err) => {
    logger.error({
      msg: `Worker job failed: ${name}`,
      jobId: job?.id,
      error: err.message,
    });
  });

  return worker;
}

// ── Graceful Shutdown ──
export async function closeAllQueues(): Promise<void> {
  await Promise.all([
    otpQueue.close(),
    notificationQueue.close(),
    paymentQueue.close(),
    fuelRateQueue.close(),
    cleanupQueue.close(),
  ]);
  logger.info("All queues closed");
}
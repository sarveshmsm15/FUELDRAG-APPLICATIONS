# ─── Stage 1: Build ───
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --ignore-scripts
COPY prisma ./prisma
RUN npx prisma generate
COPY tsconfig.json ./
COPY src ./src

# ─── Stage 2: Production ───
FROM node:22-alpine AS production
RUN addgroup -g 1001 -S appgroup && adduser -S appuser -u 1001 -G appgroup
WORKDIR /app
COPY --from=builder /app/package*.json ./
RUN npm install --omit=dev --ignore-scripts
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/src ./src
COPY --from=builder /app/tsconfig.json ./
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 3000 9090
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1
CMD ["npx", "tsx", "src/main.ts"]

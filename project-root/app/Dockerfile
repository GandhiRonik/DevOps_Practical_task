# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app ./
# Non-root user setup
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
# Environment variable support
ENV PORT=3000
ENV NODE_ENV=production
EXPOSE 3000
# Healthcheck implementation
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

CMD ["npm", "start"]
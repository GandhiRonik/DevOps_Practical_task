# ==========================================
# STAGE 1: Build dependencies
# ==========================================
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files and install dependencies
COPY app/package*.json ./
RUN npm ci

# Copy the rest of the application code
COPY app/ .

# ==========================================
# STAGE 2: Production Image
# ==========================================
FROM node:18-alpine

WORKDIR /app

# Best Practice: Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy built artifacts from the builder stage
COPY --from=builder /app /app

# Set ownership to the non-root user
RUN chown -R appuser:appgroup /app

# Switch to the non-root user
USER appuser

# Support Environment Variables
ENV PORT=8080
ENV NODE_ENV=production

# Best Practice: Container Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/ || exit 1

# Expose the port the app runs on
EXPOSE 8080

# Start the application
CMD ["npm", "start"]



# # Stage 1: Build
# FROM node:18-alpine AS builder
# WORKDIR /app
# COPY package*.json ./
# RUN npm ci
# COPY . .

# # Stage 2: Production
# FROM node:18-alpine
# WORKDIR /app
# COPY --from=builder /app ./
# # Non-root user setup
# RUN addgroup -S appgroup && adduser -S appuser -G appgroup
# USER appuser
# # Environment variable support
# ENV PORT=3000
# ENV NODE_ENV=production
# EXPOSE 3000
# # Healthcheck implementation
# HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
#   CMD wget --no-verbose --tries=1 --spider http://localhost:3000/ || exit 1

# CMD ["npm", "start"]
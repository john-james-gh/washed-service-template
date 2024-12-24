# =====================
#   Stage 1: Builder
# =====================
FROM node:lts-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies (including devDependencies)
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the TypeScript code
RUN npm run build

# =====================
#   Stage 2: Production
# =====================
FROM node:lts-alpine

# Set working directory
WORKDIR /app

# Copy ONLY package files again
COPY package*.json ./

# Install only PRODUCTION dependencies
# This step excludes devDependencies (including TypeScript)
RUN npm ci --only=production

# Copy over the compiled dist files
COPY --from=build /app/dist ./dist

# (Optional) Non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# If you have environment variables, you can set them here or pass them at runtime
ENV NODE_ENV=production
ENV PORT=3000

# Expose the port your app runs on
EXPOSE 3000

# Define the command to run your app
CMD ["node", "dist/index.js"]
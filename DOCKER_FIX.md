# Docker Fix - Missing Dependencies Error

## Problem
The frontend container shows errors about missing `@tanstack/react-query` and `axios` packages because the dependencies weren't installed in the Docker container.

## Solution

I've updated the Dockerfiles to automatically run `npm install` on container startup. This ensures dependencies are always up-to-date even when using mounted volumes.

### What Changed

**Frontend Dockerfile:**
- Now runs `npm install` before starting the dev server
- This ensures React Query, Axios, and other new dependencies are installed

**Backend Dockerfile:**
- Also runs `npm install` before starting
- Ensures all backend dependencies are present

## How to Fix

### Option 1: Rebuild containers (Recommended)
```bash
# Stop current containers
docker compose down

# Rebuild and start
docker compose up --build
```

### Option 2: If rebuild doesn't work
```bash
# Stop everything
docker compose down -v

# Remove node_modules from host (if needed)
rm -rf frontend/node_modules
rm -rf backend/node_modules

# Rebuild
docker compose up --build
```

### Option 3: Install locally first (Best for development)
```bash
# Install on host machine
cd frontend
npm install
cd ../backend
npm install
cd ..

# Then start Docker
docker compose up
```

## Why This Happened

When you mount volumes in Docker (`./frontend:/app`), it overrides the container's files with your local files. If you don't have `node_modules` locally or they're out of sync, the container can't find the dependencies.

The fix ensures `npm install` runs every time the container starts, keeping dependencies in sync.

## Expected Result

After rebuilding, you should see:
```
meetings-quality-frontend | added XXX packages
meetings-quality-frontend | ✨ optimized dependencies
meetings-quality-frontend | 4:XX:XX PM [vite] server running at:
meetings-quality-frontend | ➜  Local:   http://localhost:3000/
```

No more "Failed to resolve import" errors! 🎉

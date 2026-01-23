# Backend Fix for Digital Ocean

## Problem
Backend was trying to run production mode (`start:prod`) but the `dist` folder was missing because volume mounts replace the built files.

## Solution
Changed to development mode with build on startup.

## What I Fixed

**backend/Dockerfile:**
- Now builds at startup (after volumes mount)
- Runs in development mode (`start:dev`)
- Generates OpenAPI spec

**docker-compose.yml:**
- Added `/app/dist` volume to persist build
- Changed NODE_ENV to `development`

## Deploy the Fix on Your Droplet

Run these commands:

```bash
# Navigate to project
cd /path/to/meetings-quality-mono

# Stop containers
docker compose down

# Rebuild backend
docker compose up -d --build backend

# Wait a moment for backend to build and start
sleep 30

# Start nginx
docker compose up -d nginx

# Check logs
docker compose logs -f backend
```

You should see:
```
✅ OpenAPI specification generated successfully!
🚀 Application is running on port: 4000
```

Then access: **http://209.38.214.211**

## Verify It Works

```bash
# Check all containers are running
docker compose ps

# Should show all 4 services as "Up"
```

## If Still Having Issues

**Check backend logs:**
```bash
docker compose logs backend --tail=100
```

**Restart everything:**
```bash
docker compose down
docker compose up -d --build
```

**Wait for backend to finish building:**
The first startup takes 1-2 minutes because it:
1. Installs dependencies
2. Builds TypeScript
3. Generates OpenAPI spec
4. Starts server

Be patient and watch the logs!

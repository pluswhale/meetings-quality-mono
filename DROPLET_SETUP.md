# Digital Ocean Droplet Setup

## What I Fixed

The frontend was hanging because it was waiting for a backend file that doesn't exist in separate Docker containers. I fixed:

1. ✅ Frontend now fetches OpenAPI spec via HTTP from backend
2. ✅ Backend won't fail if OpenAPI generation has issues
3. ✅ Added wget to both containers for health checks

## Deploy on Your Droplet (209.38.214.211)

### 1. Check Firewall (IMPORTANT!)

```bash
# Check current firewall status
sudo ufw status

# If inactive, enable it
sudo ufw enable

# Allow required ports
sudo ufw allow 22      # SSH
sudo ufw allow 3000    # Frontend
sudo ufw allow 4000    # Backend

# Verify
sudo ufw status numbered
```

### 2. Pull Latest Code & Deploy

```bash
# Navigate to your project
cd /path/to/meetings-quality-mono

# Pull latest changes (if using git)
git pull

# Stop old containers
docker compose down

# Rebuild and start
docker compose up -d --build

# Watch logs to see if services start
docker compose logs -f
```

### 3. Check Container Status

```bash
# See if containers are running
docker compose ps

# Should show:
# - meetings-quality-mongodb    (healthy)
# - meetings-quality-backend    (running)
# - meetings-quality-frontend   (running)
```

### 4. Check Logs for Errors

```bash
# Backend logs
docker compose logs backend

# Look for: "🚀 Application is running on port: 4000"

# Frontend logs  
docker compose logs frontend

# Look for: "🚀 Starting Vite dev server..."
```

### 5. Test Access

```bash
# From your droplet, test locally
curl http://localhost:4000/api
curl http://localhost:3000

# Both should return HTML/JSON responses
```

### 6. Access from Browser

- Frontend: http://209.38.214.211:3000
- Backend: http://209.38.214.211:4000/api

## Troubleshooting

### Issue: "Connection refused" from browser

**Solution:** Check firewall
```bash
sudo ufw allow 3000
sudo ufw allow 4000
```

### Issue: Container exits immediately

**Check logs:**
```bash
docker compose logs backend
docker compose logs frontend
```

### Issue: MongoDB connection error

**Restart MongoDB:**
```bash
docker compose restart mongodb
sleep 5
docker compose restart backend
```

### Issue: Frontend shows "Network Error"

**Check backend is running:**
```bash
docker compose logs backend
curl http://localhost:4000/api
```

**Verify VITE_API_URL in docker-compose.yml matches your IP**

## Quick Commands

```bash
# View all logs
docker compose logs -f

# Restart everything
docker compose restart

# Stop everything
docker compose down

# Rebuild everything
docker compose up -d --build

# Remove all and start fresh
docker compose down -v
docker compose up -d --build
```

## Files Changed

- ✅ `backend/Dockerfile` - Made OpenAPI generation non-blocking
- ✅ `frontend/Dockerfile` - Added wget for backend health checks
- ✅ `frontend/wait-for-openapi.sh` - Fetch OpenAPI via HTTP instead of file

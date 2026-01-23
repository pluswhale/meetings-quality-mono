# Nginx Setup Instructions for Digital Ocean

## What This Setup Does

- ✅ Frontend accessible at: **http://209.38.214.211** (port 80)
- ✅ Backend API at: **http://209.38.214.211/api**
- ✅ WebSocket support for real-time features
- ✅ All traffic goes through Nginx (professional setup)

## Deploy on Your Droplet (209.38.214.211)

### 1. Open Firewall for Port 80

```bash
# Allow HTTP traffic (port 80)
sudo ufw allow 80/tcp

# Check firewall status
sudo ufw status
```

You should see:
```
80/tcp         ALLOW       Anywhere
```

### 2. Deploy with Docker Compose

```bash
# Navigate to your project
cd /path/to/meetings-quality-mono

# Stop old containers
docker compose down

# Rebuild and start with Nginx
docker compose up -d --build

# Watch logs
docker compose logs -f
```

### 3. Verify Services Are Running

```bash
docker compose ps
```

You should see 4 containers running:
- `meetings-quality-mongodb`
- `meetings-quality-backend`
- `meetings-quality-frontend`
- `meetings-quality-nginx`

### 4. Test Access

**From your browser:**
- Open: **http://209.38.214.211**

You should see your frontend application!

**Test API:**
- Open: **http://209.38.214.211/api**

You should see Swagger documentation!

## How It Works

```
Internet → Nginx (port 80) → Frontend (port 3000)
                           → Backend (port 4000)
```

- Nginx listens on port 80 (standard HTTP)
- Frontend requests go to frontend container
- `/api` requests are proxied to backend
- `/socket.io` requests are proxied for WebSocket
- Ports 3000 and 4000 are NOT exposed externally (more secure)

## Files Created

```
nginx/
└── nginx.conf          # Nginx configuration
```

## Files Modified

```
docker-compose.yml      # Added nginx service
frontend/Dockerfile     # Simplified startup
```

## Troubleshooting

### Issue: "Connection refused" on port 80

**Check firewall:**
```bash
sudo ufw allow 80/tcp
sudo ufw status
```

**Check nginx is running:**
```bash
docker compose ps nginx
docker compose logs nginx
```

### Issue: "502 Bad Gateway"

**Backend or Frontend not ready:**
```bash
# Check if backend is running
docker compose logs backend

# Check if frontend is running
docker compose logs frontend

# Restart services
docker compose restart backend frontend
sleep 10
docker compose restart nginx
```

### Issue: API requests fail

**Check nginx configuration:**
```bash
docker compose exec nginx nginx -t
```

**View nginx access logs:**
```bash
docker compose logs nginx
```

### Issue: WebSocket not working

**Check browser console for errors**

**Verify WebSocket URL in frontend:**
- Should be: `ws://209.38.214.211/socket.io`

## Quick Commands

```bash
# View all logs
docker compose logs -f

# View nginx logs only
docker compose logs -f nginx

# Restart nginx
docker compose restart nginx

# Restart everything
docker compose restart

# Stop everything
docker compose down

# Full rebuild
docker compose down
docker compose up -d --build
```

## What Changed in Your Setup

**Before:**
- Frontend on port 3000
- Backend on port 4000
- Direct access to each service

**After:**
- Everything on port 80 (standard HTTP)
- Nginx handles all incoming traffic
- More professional and secure setup
- Ready for SSL later (if needed)

## Next Steps (Optional)

1. ✅ Basic setup done - access via http://209.38.214.211
2. Get a domain name (e.g., yourdomain.com)
3. Point domain to 209.38.214.211
4. Update nginx.conf with your domain
5. Add SSL certificate with Let's Encrypt

## Summary

Just run these commands on your droplet:

```bash
cd /path/to/meetings-quality-mono
sudo ufw allow 80/tcp
docker compose down
docker compose up -d --build
```

Then open: **http://209.38.214.211**

Done! 🎉

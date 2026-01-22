# ✅ Automatic API Generation in Docker

## What Was Added

Both backend and frontend now **automatically generate API code** on every Docker startup!

---

## Backend: Auto-Generate OpenAPI Spec

### File: `backend/Dockerfile`

**Changed CMD to include OpenAPI generation:**
```dockerfile
CMD ["sh", "-c", "npm install && npm run openapi:generate && npm run start:dev"]
```

**What happens:**
1. 📦 Installs dependencies (if package.json changed)
2. 📄 **Generates OpenAPI spec** → `backend/generated/openapi.json`
3. 🚀 Starts NestJS in dev mode

---

## Frontend: Auto-Generate API Client

### Files Created/Modified:

#### 1. `frontend/wait-for-openapi.sh` (NEW)
Smart wait script that:
- ⏳ Waits up to 60 seconds for backend OpenAPI file
- ✅ Generates API client when file is ready
- 🚀 Starts Vite dev server

#### 2. `frontend/Dockerfile` (UPDATED)
```dockerfile
# Copy and make executable
COPY wait-for-openapi.sh /app/wait-for-openapi.sh
RUN chmod +x /app/wait-for-openapi.sh

# Run wait script instead of direct command
CMD ["sh", "-c", "npm install && /app/wait-for-openapi.sh"]
```

**What happens:**
1. 📦 Installs dependencies (if package.json changed)
2. ⏳ **Waits for** `backend/generated/openapi.json`
3. 🔄 **Generates API client** → `frontend/src/api/generated/`
4. 🚀 Starts Vite dev server

---

## How It Works

### Startup Flow:

```
1. docker-compose up
   ↓
2. Backend starts → generates OpenAPI spec
   ↓
3. Frontend waits for OpenAPI spec
   ↓
4. Frontend generates API client
   ↓
5. Both services ready! ✅
```

### Timing Protection:

The frontend wait script prevents race conditions:
- If OpenAPI file exists → immediate generation
- If not → waits up to 60 seconds
- If timeout → starts anyway (with warning)

---

## Benefits

### ✅ Always Up-to-Date
- Frontend API client automatically matches backend changes
- No manual regeneration needed
- No stale API types

### ✅ Developer-Friendly
- Just run `docker-compose up`
- Everything generates automatically
- No extra steps needed

### ✅ Production-Ready
- Ensures consistency across environments
- Prevents API mismatches
- Clean rebuild every time

---

## Commands Overview

| Service | Script | When | Output |
|---------|--------|------|--------|
| **Backend** | `npm run openapi:generate` | Every startup | `backend/generated/openapi.json` |
| **Frontend** | `npm run generate:api` | After backend ready | `frontend/src/api/generated/*` |

---

## Testing

### Test 1: Clean Start
```bash
# Stop everything
docker-compose down

# Remove generated files (optional)
rm -rf backend/generated frontend/src/api/generated

# Start fresh
docker-compose up --build

# Watch logs:
# - Backend: "✅ OpenAPI spec generated"
# - Frontend: "⏳ Waiting for backend OpenAPI spec..."
#            "✅ OpenAPI spec found! Generating API client..."
#            "✅ API client generated!"
```

### Test 2: Backend Change
```bash
# 1. Change backend controller/DTO
# 2. Save file (backend auto-reloads)
# 3. OpenAPI regenerates automatically
# 4. Restart frontend container:
docker-compose restart frontend
# Frontend regenerates API client ✅
```

---

## File Structure

```
meetings-quality-mono/
├── backend/
│   ├── Dockerfile                          # ← Updated
│   ├── generated/
│   │   └── openapi.json                    # ← Auto-generated on startup
│   └── scripts/
│       └── generate-openapi.ts             # ← Script that generates
│
├── frontend/
│   ├── Dockerfile                          # ← Updated
│   ├── wait-for-openapi.sh                 # ← NEW
│   ├── orval.config.ts                     # Points to ../backend/generated/openapi.json
│   └── src/
│       └── api/
│           └── generated/                  # ← Auto-generated after backend ready
│
└── docker-compose.yml                      # frontend depends_on backend
```

---

## Troubleshooting

### Frontend starts before backend generates OpenAPI

**Symptom:**
```
❌ Timeout waiting for OpenAPI spec. Backend might not be ready.
⚠️ Starting frontend anyway...
```

**Solutions:**
1. **Wait longer:** Edit `wait-for-openapi.sh` → increase `MAX_WAIT=60` to `MAX_WAIT=120`
2. **Check backend logs:** `docker-compose logs backend`
3. **Manually restart frontend:** `docker-compose restart frontend`

### OpenAPI generation fails

**Check backend logs:**
```bash
docker-compose logs backend | grep openapi
```

**Common issues:**
- Missing `generated/` folder → create it: `mkdir backend/generated`
- Script error → check `backend/scripts/generate-openapi.ts`

### Frontend generation fails

**Check frontend logs:**
```bash
docker-compose logs frontend | grep generate
```

**Common issues:**
- Orval config error → check `frontend/orval.config.ts`
- Missing axios-instance → ensure `frontend/src/api/axios-instance.ts` exists

---

## Manual Regeneration (if needed)

### Backend:
```bash
docker-compose exec backend npm run openapi:generate
```

### Frontend:
```bash
docker-compose exec frontend npm run generate:api
```

---

## 🎯 Summary

**Before:**
- ❌ Manual API generation required
- ❌ Easy to forget
- ❌ Stale API types

**After:**
- ✅ Automatic generation on startup
- ✅ Always synchronized
- ✅ Zero manual steps
- ✅ Developer-friendly workflow

🚀 **Just run `docker-compose up` and everything works!**

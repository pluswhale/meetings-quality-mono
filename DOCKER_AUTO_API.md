# 🔄 Automatic API Generation in Docker - Quick Guide

## ✅ What's New

Every time you run `docker-compose up`, both services automatically generate API code!

---

## 📋 Files Changed

### 1. Backend Dockerfile ✅
**Added:** OpenAPI generation before starting
```dockerfile
CMD ["sh", "-c", "npm install && npm run openapi:generate && npm run start:dev"]
```

### 2. Frontend Dockerfile ✅
**Added:** Wait for backend + API generation
```dockerfile
COPY wait-for-openapi.sh /app/wait-for-openapi.sh
RUN chmod +x /app/wait-for-openapi.sh
CMD ["sh", "-c", "npm install && /app/wait-for-openapi.sh"]
```

### 3. Frontend wait-for-openapi.sh (NEW) ✅
Smart script that:
- Waits for backend OpenAPI file (max 60 seconds)
- Generates API client when ready
- Starts Vite dev server

### 4. .dockerignore Files ✅
- **Backend:** Added `generated` (won't copy into container)
- **Frontend:** Added `src/api/generated` (will regenerate fresh)

---

## 🚀 How to Use

### Simple Start:
```bash
docker-compose up --build
```

That's it! Everything generates automatically.

### What You'll See:

**Backend logs:**
```
✅ OpenAPI spec generated at: backend/generated/openapi.json
🚀 NestJS application started
```

**Frontend logs:**
```
⏳ Waiting for backend OpenAPI spec...
✅ OpenAPI spec found! Generating API client...
✅ API client generated!
🚀 Starting Vite dev server...
```

---

## 📊 Flow Chart

```
docker-compose up
       ↓
   Backend:
   1. npm install
   2. npm run openapi:generate  → backend/generated/openapi.json
   3. npm run start:dev
       ↓
   Frontend:
   1. npm install
   2. Wait for backend OpenAPI file (max 60s)
   3. npm run generate:api      → frontend/src/api/generated/*
   4. npm run dev
       ↓
   ✅ Both services ready!
```

---

## 🔍 Generated Files

### Backend generates:
```
backend/
└── generated/
    └── openapi.json    ← OpenAPI 3.0 specification
```

### Frontend generates:
```
frontend/
└── src/
    └── api/
        └── generated/
            ├── models/        ← TypeScript types
            │   ├── index.ts
            │   ├── authResponseDto.ts
            │   ├── meetingResponseDto.ts
            │   └── ...
            ├── meetings/      ← Meetings API hooks
            │   └── meetings.ts
            ├── tasks/         ← Tasks API hooks
            │   └── tasks.ts
            ├── users/         ← Users API hooks
            │   └── users.ts
            └── hooks/         ← Combined exports
                └── index.ts
```

---

## 🛠️ Manual Commands (if needed)

### Backend only:
```bash
docker-compose exec backend npm run openapi:generate
```

### Frontend only:
```bash
docker-compose exec frontend npm run generate:api
```

### Restart to regenerate:
```bash
docker-compose restart backend frontend
```

---

## ⚠️ Important Notes

### 1. Clean Build
If things seem out of sync:
```bash
docker-compose down
docker-compose up --build
```

### 2. Backend Changes
When you modify backend API:
- Backend auto-reloads (watch mode)
- OpenAPI regenerates automatically
- **Restart frontend** to regenerate client:
  ```bash
  docker-compose restart frontend
  ```

### 3. Timing
- Frontend waits up to **60 seconds** for backend
- Usually takes **5-10 seconds**
- If timeout → check backend logs

---

## 🎯 Benefits

| Before | After |
|--------|-------|
| ❌ Manual `npm run openapi:generate` | ✅ Automatic on startup |
| ❌ Manual `npm run generate:api` | ✅ Automatic after backend ready |
| ❌ Easy to forget | ✅ Never forget |
| ❌ Stale API types | ✅ Always fresh |
| ❌ Extra commands | ✅ Zero extra steps |

---

## 📝 Summary

**You changed:**
- ✅ `backend/Dockerfile` - auto-generate OpenAPI
- ✅ `frontend/Dockerfile` - auto-generate API client
- ✅ `frontend/wait-for-openapi.sh` - smart wait script
- ✅ `.dockerignore` files - exclude generated folders

**Result:**
- 🔄 API always synchronized
- 🚀 One command: `docker-compose up`
- ✨ Everything just works!

---

## 🧪 Test It Now

```bash
# Stop everything
docker-compose down

# Start fresh
docker-compose up --build

# Watch the logs for automatic generation! 🎉
```

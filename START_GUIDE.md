# 🚀 Quick Start Guide

## ✨ What's Ready

Your monorepo now has:
- ✅ **Auto API Generation** - Backend and frontend sync automatically
- ✅ **Open Access** - All users can view and participate in meetings
- ✅ **Creator Controls** - Only creators can advance phases

---

## 🎯 Start in 3 Steps

### 1️⃣ Start Docker
```bash
docker-compose up --build
```

### 2️⃣ Wait for Services
Watch the logs for:
```
backend   | ✅ OpenAPI spec generated
frontend  | ✅ API client generated!
frontend  | 🚀 Starting Vite dev server...
```

### 3️⃣ Open Browser
```
Frontend: http://localhost:3000
Backend API: http://localhost:4000
```

---

## 👥 Test Scenarios

### Create a Meeting (User 1)
1. Register/Login as `user1@test.com`
2. Click **"Создать встречу"**
3. Fill in title and question
4. Click **"Запустить процесс"**
5. You'll see **"Следующая фаза"** button ✅

### Join as Participant (User 2)
1. Register/Login as `user2@test.com`
2. Dashboard shows User 1's meeting ✅
3. Click the meeting to view it ✅
4. You can evaluate/summarize ✅
5. You WON'T see "Следующая фаза" button ✅

---

## 🔧 Development Workflow

### Regular Work
```bash
# Start
docker-compose up

# Make changes to code
# Services auto-reload!

# Stop
Ctrl+C
```

### After Backend API Changes
```bash
# Backend auto-reloads and regenerates OpenAPI
# Restart frontend to get new API client:
docker-compose restart frontend
```

### Clean Rebuild
```bash
docker-compose down
docker-compose up --build
```

---

## 📊 What Happens Automatically

| Service | Automatic Actions |
|---------|-------------------|
| **Backend** | 1. Install dependencies<br>2. Generate OpenAPI spec<br>3. Start NestJS |
| **Frontend** | 1. Install dependencies<br>2. Wait for backend OpenAPI<br>3. Generate API client<br>4. Start Vite |

---

## 🐛 Troubleshooting

### Frontend starts but shows errors
```bash
# Regenerate API manually:
docker-compose exec frontend npm run generate:api
docker-compose restart frontend
```

### Backend OpenAPI not generating
```bash
# Check backend logs:
docker-compose logs backend | grep openapi

# Generate manually:
docker-compose exec backend npm run openapi:generate
```

### Services won't start
```bash
# Clean everything:
docker-compose down -v
docker-compose up --build
```

---

## 📁 Key Files

### Backend
- `backend/Dockerfile` - Auto-generates OpenAPI
- `backend/src/meetings/meetings.service.ts` - Open access logic

### Frontend
- `frontend/Dockerfile` - Auto-generates API client
- `frontend/wait-for-openapi.sh` - Smart wait script
- `frontend/screens/MeetingDetail.tsx` - Fixed creator detection

---

## 📖 Documentation

- **CHANGES_SUMMARY.md** - All changes explained
- **BACKEND_FIX_OPEN_ACCESS.md** - Backend open access details
- **AUTO_GENERATE_API.md** - Generation system explained
- **DOCKER_AUTO_API.md** - Quick reference

---

## 🎉 You're Ready!

```bash
docker-compose up --build
```

Then open http://localhost:3000 and start using your app! 🚀

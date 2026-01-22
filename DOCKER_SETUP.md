# Docker Setup Guide

This guide will help you run the Meetings Quality monorepo with Docker.

## Prerequisites

- Docker Desktop installed and running
- Docker Compose installed

## Quick Start

1. **Create environment files** (they're gitignored, so create them manually):

### Backend `.env` file
Create `backend/.env` with:
```env
# MongoDB - using Docker service name
MONGODB_URI=mongodb://mongodb:27017/meetings-quality

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRATION=7d

# Application
PORT=4000
NODE_ENV=development

# CORS - using Docker service name
FRONTEND_URL=http://localhost:3000
```

### Frontend `.env` file
Create `frontend/.env` with:
```env
# Backend API URL
VITE_API_URL=http://localhost:4000

# WebSocket URL
VITE_WS_URL=ws://localhost:4000
```

2. **Build and start all services**:
```bash
docker-compose up --build
```

Or run in detached mode:
```bash
docker-compose up -d --build
```

3. **Access the applications**:
- Frontend: http://localhost:3000
- Backend API: http://localhost:4000
- Swagger Documentation: http://localhost:4000/api
- MongoDB: localhost:27017

## Useful Commands

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f frontend
docker-compose logs -f backend
docker-compose logs -f mongodb
```

### Stop services
```bash
docker-compose down
```

### Stop and remove volumes (fresh start)
```bash
docker-compose down -v
```

### Rebuild a specific service
```bash
docker-compose up -d --build backend
docker-compose up -d --build frontend
```

### Execute commands in containers
```bash
# Backend shell
docker-compose exec backend sh

# Frontend shell
docker-compose exec frontend sh

# MongoDB shell
docker-compose exec mongodb mongosh
```

## Architecture

```
┌─────────────────┐
│   Frontend      │
│   (React+Vite)  │
│   Port: 3000    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   Backend       │
│   (NestJS)      │
│   Port: 4000    │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│   MongoDB       │
│   Port: 27017   │
└─────────────────┘
```

## Troubleshooting

### Port already in use
If you get an error about ports already in use, either:
- Stop the service using that port
- Change the port mapping in `docker-compose.yml`

### Node modules issues
If you encounter node_modules issues:
```bash
docker-compose down -v
docker-compose up --build
```

### Database connection issues
Make sure MongoDB container is running:
```bash
docker-compose ps
```

Check MongoDB logs:
```bash
docker-compose logs mongodb
```

## Development Workflow

The volumes are mounted so changes to your code will be reflected immediately:
- Frontend: Hot reload enabled via Vite
- Backend: Watch mode enabled via NestJS

You don't need to rebuild containers for code changes, just edit and save!

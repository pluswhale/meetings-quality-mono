# Meetings Quality Platform - Monorepo

A full-stack application for tracking and evaluating meeting quality. Built with NestJS (backend) and React + Vite (frontend).

## 🏗️ Architecture

```
meetings-quality-mono/
├── backend/          # NestJS API
├── frontend/         # React + Vite SPA
├── docker-compose.yml
└── DOCKER_SETUP.md   # Detailed Docker guide
```

## 🚀 Quick Start with Docker

### Prerequisites
- Docker Desktop installed and running
- Node.js 20+ (for local development without Docker)

### Start Everything with Docker

1. **Clone and navigate to the repository**
```bash
cd meetings-quality-mono
```

2. **Run the startup script** (Unix/Mac)
```bash
chmod +x start-docker.sh
./start-docker.sh
```

Or **manually**:
```bash
# Create .env files (see DOCKER_SETUP.md for contents)
# Then run:
docker-compose up --build
```

3. **Access the applications**
- Frontend: http://localhost:3000
- Backend API: http://localhost:4000
- API Documentation: http://localhost:4000/api
- MongoDB: localhost:27017

### Stop Services
```bash
docker-compose down
```

## 🛠️ Local Development (Without Docker)

### Backend
```bash
cd backend
npm install
# Create .env file (see backend/env.example)
npm run start:dev
```

### Frontend
```bash
cd frontend
npm install
# Create .env file (see frontend/.env.example)
npm run dev
```

## 📚 Documentation

- [Docker Setup Guide](./DOCKER_SETUP.md) - Comprehensive Docker guide
- [Backend API Documentation](./backend/API.md) - API endpoints and usage
- [Frontend README](./frontend/README.md) - Frontend architecture
- [Backend README](./backend/README.md) - Backend architecture

## 🧪 Features

- **Real-time Meeting Management** - WebSocket support for live updates
- **User Authentication** - JWT-based auth with Passport
- **Meeting Phases** - Structured meeting lifecycle (Planning → Active → Review → Completed)
- **Task Management** - Create and track action items from meetings
- **Quality Evaluation** - Rate and review meeting effectiveness
- **Modern UI** - Beautiful, responsive interface with Framer Motion animations

## 🗄️ Tech Stack

### Backend
- NestJS
- MongoDB + Mongoose
- JWT Authentication
- WebSockets (Socket.IO)
- Swagger/OpenAPI

### Frontend
- React 19
- TypeScript
- Vite
- Zustand (State Management)
- React Router
- Framer Motion

### DevOps
- Docker & Docker Compose
- MongoDB Container

## 🔧 Environment Variables

### Backend (.env)
```env
MONGODB_URI=mongodb://mongodb:27017/meetings-quality
JWT_SECRET=your-secret-key
JWT_EXPIRATION=7d
PORT=4000
NODE_ENV=development
FRONTEND_URL=http://localhost:3000
```

### Frontend (.env)
```env
VITE_API_URL=http://localhost:4000
VITE_WS_URL=ws://localhost:4000
```

## 📊 Available Scripts

### Root Level
- `./start-docker.sh` - Start all services with Docker

### Backend
- `npm run start:dev` - Start backend in development mode
- `npm run build` - Build for production
- `npm run test` - Run tests
- `npm run openapi:generate` - Generate OpenAPI spec

### Frontend
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build

## 🐛 Troubleshooting

See [DOCKER_SETUP.md](./DOCKER_SETUP.md#troubleshooting) for common issues and solutions.

## 📝 License

MIT

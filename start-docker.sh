#!/bin/bash

# Startup script for Meetings Quality Monorepo in Docker

echo "🚀 Starting Meetings Quality Platform in Docker..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop and try again."
    exit 1
fi

# Check if .env files exist
if [ ! -f "./backend/.env" ]; then
    echo "⚠️  Backend .env file not found. Creating from example..."
    if [ -f "./backend/env.example" ]; then
        cp ./backend/env.example ./backend/.env
        # Update MongoDB URI for Docker
        sed -i '' 's|mongodb+srv://.*|mongodb://mongodb:27017/meetings-quality|' ./backend/.env 2>/dev/null || \
        sed -i 's|mongodb+srv://.*|mongodb://mongodb:27017/meetings-quality|' ./backend/.env
        sed -i '' 's|PORT=3000|PORT=4000|' ./backend/.env 2>/dev/null || \
        sed -i 's|PORT=3000|PORT=4000|' ./backend/.env
        echo "✅ Backend .env created"
    else
        echo "❌ backend/env.example not found. Please create backend/.env manually."
        exit 1
    fi
fi

if [ ! -f "./frontend/.env" ]; then
    echo "⚠️  Frontend .env file not found. Creating..."
    cat > ./frontend/.env << EOF
# Backend API URL
VITE_API_URL=http://localhost:4000

# WebSocket URL
VITE_WS_URL=ws://localhost:4000
EOF
    echo "✅ Frontend .env created"
fi

echo ""
echo "📦 Building and starting containers..."
docker-compose up --build -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 5

echo ""
echo "✅ All services are starting up!"
echo ""
echo "📱 Access your applications:"
echo "   Frontend:  http://localhost:3000"
echo "   Backend:   http://localhost:4000"
echo "   API Docs:  http://localhost:4000/api"
echo "   MongoDB:   mongodb://localhost:27017"
echo ""
echo "📊 View logs with: docker-compose logs -f"
echo "🛑 Stop with: docker-compose down"
echo ""

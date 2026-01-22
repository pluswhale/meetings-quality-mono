#!/bin/bash

echo "🔧 Quick Fix for Docker Dependencies Issue"
echo ""

# Stop containers
echo "1️⃣ Stopping containers..."
docker compose down

# Install dependencies locally (optional but recommended)
echo ""
echo "2️⃣ Installing dependencies locally..."
echo "   Installing frontend dependencies..."
cd frontend && npm install
echo "   ✅ Frontend dependencies installed"

cd ..
echo "   Installing backend dependencies..."
cd backend && npm install
echo "   ✅ Backend dependencies installed"

cd ..

# Rebuild containers
echo ""
echo "3️⃣ Rebuilding and starting Docker containers..."
docker compose up --build -d

echo ""
echo "✅ Fix complete! Check the logs:"
echo "   docker compose logs -f frontend"
echo ""
echo "🌐 Your app should be running at:"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:4000"

@echo off
REM Minimal build script - builds services without heavy ML packages first (Windows)
setlocal enabledelayedexpansion

echo 🚀 Starting minimal build (without heavy ML packages)...

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running. Please start Docker and try again.
    exit /b 1
)

REM Enable BuildKit
set DOCKER_BUILDKIT=1

echo [INFO] Building minimal services first...

REM Build services that don't need heavy ML packages
echo [INFO] Building backend...
docker-compose -f docker-compose.dev.yml build backend

echo [INFO] Building tooling services...
docker-compose -f docker-compose.dev.yml build orchestrator
docker-compose -f docker-compose.dev.yml build weather_server
docker-compose -f docker-compose.dev.yml build browser_server
docker-compose -f docker-compose.dev.yml build web_search_server
docker-compose -f docker-compose.dev.yml build reminder_server
docker-compose -f docker-compose.dev.yml build file_access_server
docker-compose -f docker-compose.dev.yml build shell_server
docker-compose -f docker-compose.dev.yml build google_calendar_server
docker-compose -f docker-compose.dev.yml build gmail_server
docker-compose -f docker-compose.dev.yml build automation_server

echo [INFO] Building MCP Gateway...
docker-compose -f docker-compose.dev.yml build mcp_gateway

echo [INFO] Building frontend...
docker-compose -f docker-compose.dev.yml build frontend

echo [WARN] Skipping worker builds for now (they need heavy ML packages)
echo [WARN] You can build workers separately with: docker-compose -f docker-compose.dev.yml build worker-cpu

echo [INFO] ✅ Minimal build completed!
echo [INFO] To start the services, run: docker-compose -f docker-compose.dev.yml up -d
echo [INFO] Workers can be built later when needed

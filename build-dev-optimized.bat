@echo off
REM Optimized build script for Synapse development environment (Windows)
REM Uses existing docker-compose.dev.yml with optimized Dockerfiles

setlocal enabledelayedexpansion

echo 🚀 Starting optimized development build...

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Docker is not running. Please start Docker and try again.
    exit /b 1
)

REM Enable BuildKit for better caching
set DOCKER_BUILDKIT=1

echo [INFO] Building optimized development environment...

REM Build all services using the existing docker-compose.dev.yml
echo [INFO] Building all services with optimized Dockerfiles...
docker-compose -f docker-compose.dev.yml build --parallel

REM Show image sizes
echo [INFO] Build completed! Image sizes:
echo.
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | findstr /E "synapse tooling mcp"

REM Clean up dangling images
echo [INFO] Cleaning up dangling images...
docker image prune -f

echo [INFO] ✅ Optimized development build completed!
echo [INFO] To start the services, run: docker-compose -f docker-compose.dev.yml up -d
echo [INFO] MCP Gateway will be available at: http://localhost:8020
echo [INFO] Health check: curl http://localhost:8020/health

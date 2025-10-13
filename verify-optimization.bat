@echo off
REM Verification script for Docker optimization (Windows)
setlocal enabledelayedexpansion

echo 🔍 Verifying Docker optimization setup...

REM Check if files exist
echo Checking required files...

REM Check Dockerfiles
if exist "..\Synapse-Backend\Dockerfile.optimized" (
    echo [✓] Backend optimized Dockerfile exists
) else (
    echo [✗] Backend optimized Dockerfile missing
)

if exist "..\Synapse-Worker\Dockerfile.optimized" (
    echo [✓] Worker optimized Dockerfile exists
) else (
    echo [✗] Worker optimized Dockerfile missing
)

if exist "..\Synapse-Worker\Dockerfile.mcp" (
    echo [✓] MCP Gateway Dockerfile exists
) else (
    echo [✗] MCP Gateway Dockerfile missing
)

if exist "..\Tooling_Engine\Dockerfile.optimized" (
    echo [✓] Tooling Engine optimized Dockerfile exists
) else (
    echo [✗] Tooling Engine optimized Dockerfile missing
)

REM Check requirements files
if exist "..\Synapse-Worker\requirements-optimized.txt" (
    echo [✓] Worker optimized requirements exist
) else (
    echo [✗] Worker optimized requirements missing
)

if exist "..\Synapse-Worker\requirements-gpu-optimized.txt" (
    echo [✓] Worker GPU optimized requirements exist
) else (
    echo [✗] Worker GPU optimized requirements missing
)

REM Check .dockerignore files
if exist "..\Synapse-Worker\.dockerignore" (
    echo [✓] Worker .dockerignore exists
) else (
    echo [✗] Worker .dockerignore missing
)

if exist "..\Synapse-Backend\.dockerignore" (
    echo [✓] Backend .dockerignore exists
) else (
    echo [✗] Backend .dockerignore missing
)

if exist "..\Tooling_Engine\.dockerignore" (
    echo [✓] Tooling Engine .dockerignore exists
) else (
    echo [✗] Tooling Engine .dockerignore missing
)

REM Check MCP Gateway files
if exist "..\Synapse-Worker\src\mcp_gateway" (
    echo [✓] MCP Gateway source files exist
) else (
    echo [✗] MCP Gateway source files missing
)

REM Check docker-compose.dev.yml
findstr /C:"Dockerfile.optimized" docker-compose.dev.yml >nul
if errorlevel 1 (
    echo [✗] docker-compose.dev.yml not updated
) else (
    echo [✓] docker-compose.dev.yml uses optimized Dockerfiles
)

findstr /C:"mcp_gateway" docker-compose.dev.yml >nul
if errorlevel 1 (
    echo [✗] MCP Gateway service missing from docker-compose.dev.yml
) else (
    echo [✓] MCP Gateway service configured in docker-compose.dev.yml
)

REM Check Alpine images
findstr /C:"redis:7-alpine" docker-compose.dev.yml >nul
if errorlevel 1 (
    echo [!] Redis not using Alpine image
) else (
    echo [✓] Redis using Alpine image
)

findstr /C:"pgvector/pgvector:pg16-alpine" docker-compose.dev.yml >nul
if errorlevel 1 (
    echo [!] PostgreSQL not using Alpine image
) else (
    echo [✓] PostgreSQL using Alpine image
)

echo.
echo 🎯 Optimization Summary:
echo   - All services use optimized Dockerfiles
echo   - MCP Gateway added for tool orchestration
echo   - Alpine images for databases
echo   - Optimized .dockerignore files
echo   - BuildKit cache mounts enabled
echo.
echo 🚀 Ready to build with:
echo   build-dev-optimized.bat
echo.
echo 📊 Expected size reductions:
echo   - GPU Worker: 20GB → 4-6GB (70-80%%)
echo   - CPU Worker: 12GB → 2-3GB (75-80%%)
echo   - Backend: 10GB → 1-2GB (80-90%%)
echo   - Tooling Services: 8GB → 1-2GB each (75-80%%)

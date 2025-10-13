@echo off
echo ========================================
echo Synapse Services Rebuild Script
echo ========================================
echo.

echo This script rebuilds containers.
echo Use this ONLY when you change requirements or system dependencies.
echo.

echo For code changes, just restart (no rebuild needed):
echo docker-compose -f docker-compose.dev.yml restart backend worker-cpu worker-gpu
echo.

echo Available options:
echo 1. Rebuild backend only
echo 2. Rebuild both workers (most common)
echo 3. Rebuild all worker services (including beat, flower)
echo 4. Rebuild backend + workers
echo 5. Exit
echo.

set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo Rebuilding backend...
    docker-compose -f docker-compose.dev.yml build backend
    echo Backend rebuilt successfully!
) else if "%choice%"=="2" (
    echo Rebuilding both workers...
    docker-compose -f docker-compose.dev.yml build worker-cpu worker-gpu
    echo Both workers rebuilt successfully!
) else if "%choice%"=="3" (
    echo Rebuilding all worker services...
    docker-compose -f docker-compose.dev.yml build worker-cpu worker-gpu beat flower
    echo All worker services rebuilt successfully!
) else if "%choice%"=="4" (
    echo Rebuilding backend + workers...
    docker-compose -f docker-compose.dev.yml build backend worker-cpu worker-gpu
    echo Backend and workers rebuilt successfully!
) else if "%choice%"=="5" (
    echo Exiting...
    exit /b 0
) else (
    echo Invalid choice. Please run the script again.
    exit /b 1
)

echo.
echo ========================================
echo Rebuild completed!
echo ========================================
echo.
echo To restart the services, run:
echo docker-compose -f docker-compose.dev.yml up -d backend worker-cpu worker-gpu
echo.
pause

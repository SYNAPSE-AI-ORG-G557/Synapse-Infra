@echo off
echo ========================================
echo Docker Caching Test
echo ========================================
echo.

echo This script will test if Docker caching works properly.
echo It will build the services twice and show the build times.
echo.

echo Step 1: First build (should be slow - full build)
echo ========================================
echo Building services for the first time...
docker-compose -f docker-compose.dev.yml build backend worker-cpu worker-gpu

echo.
echo Step 2: Second build (should be fast - cached)
echo ========================================
echo Building services again (should use cache)...
docker-compose -f docker-compose.dev.yml build backend worker-cpu worker-gpu

echo.
echo ========================================
echo Test completed!
echo ========================================
echo.
echo If the second build was much faster and showed "CACHED" 
echo for most steps, then Docker caching is working correctly.
echo.
echo Now try making a code change and running:
echo docker-compose -f docker-compose.dev.yml restart backend worker-cpu worker-gpu
echo.
echo This should be instant (no rebuild needed)!
echo.
pause

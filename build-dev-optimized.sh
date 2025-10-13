#!/bin/bash

# Optimized build script for Synapse development environment
# Uses existing docker-compose.dev.yml with optimized Dockerfiles

set -e

echo "🚀 Starting optimized development build..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Enable BuildKit for better caching
export DOCKER_BUILDKIT=1

print_status "Building optimized development environment..."

# Build all services using the existing docker-compose.dev.yml
print_status "Building all services with optimized Dockerfiles..."
docker-compose -f docker-compose.dev.yml build --parallel

# Show image sizes
print_status "Build completed! Image sizes:"
echo ""
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" | grep -E "(synapse|tooling|mcp)"

# Clean up dangling images
print_status "Cleaning up dangling images..."
docker image prune -f

print_status "✅ Optimized development build completed!"
print_status "To start the services, run: docker-compose -f docker-compose.dev.yml up -d"
print_status "MCP Gateway will be available at: http://localhost:8020"
print_status "Health check: curl http://localhost:8020/health"

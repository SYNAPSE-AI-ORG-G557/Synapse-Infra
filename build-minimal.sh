#!/bin/bash

# Minimal build script - builds services without heavy ML packages first
set -e

echo "🚀 Starting minimal build (without heavy ML packages)..."

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

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

# Enable BuildKit
export DOCKER_BUILDKIT=1

print_status "Building minimal services first..."

# Build services that don't need heavy ML packages
print_status "Building backend..."
docker-compose -f docker-compose.dev.yml build backend

print_status "Building tooling services..."
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

print_status "Building MCP Gateway..."
docker-compose -f docker-compose.dev.yml build mcp_gateway

print_status "Building frontend..."
docker-compose -f docker-compose.dev.yml build frontend

print_warning "Skipping worker builds for now (they need heavy ML packages)"
print_warning "You can build workers separately with: docker-compose -f docker-compose.dev.yml build worker-cpu"

print_status "✅ Minimal build completed!"
print_status "To start the services, run: docker-compose -f docker-compose.dev.yml up -d"
print_status "Workers can be built later when needed"

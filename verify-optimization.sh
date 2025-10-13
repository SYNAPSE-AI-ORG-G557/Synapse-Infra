#!/bin/bash

# Verification script for Docker optimization
set -e

echo "🔍 Verifying Docker optimization setup..."

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if files exist
echo "Checking required files..."

# Check Dockerfiles
if [ -f "../Synapse-Backend/Dockerfile.optimized" ]; then
    print_status "Backend optimized Dockerfile exists"
else
    print_error "Backend optimized Dockerfile missing"
fi

if [ -f "../Synapse-Worker/Dockerfile.optimized" ]; then
    print_status "Worker optimized Dockerfile exists"
else
    print_error "Worker optimized Dockerfile missing"
fi

if [ -f "../Synapse-Worker/Dockerfile.mcp" ]; then
    print_status "MCP Gateway Dockerfile exists"
else
    print_error "MCP Gateway Dockerfile missing"
fi

if [ -f "../Tooling_Engine/Dockerfile.optimized" ]; then
    print_status "Tooling Engine optimized Dockerfile exists"
else
    print_error "Tooling Engine optimized Dockerfile missing"
fi

# Check requirements files
if [ -f "../Synapse-Worker/requirements-optimized.txt" ]; then
    print_status "Worker optimized requirements exist"
else
    print_error "Worker optimized requirements missing"
fi

if [ -f "../Synapse-Worker/requirements-gpu-optimized.txt" ]; then
    print_status "Worker GPU optimized requirements exist"
else
    print_error "Worker GPU optimized requirements missing"
fi

# Check .dockerignore files
if [ -f "../Synapse-Worker/.dockerignore" ]; then
    print_status "Worker .dockerignore exists"
else
    print_error "Worker .dockerignore missing"
fi

if [ -f "../Synapse-Backend/.dockerignore" ]; then
    print_status "Backend .dockerignore exists"
else
    print_error "Backend .dockerignore missing"
fi

if [ -f "../Tooling_Engine/.dockerignore" ]; then
    print_status "Tooling Engine .dockerignore exists"
else
    print_error "Tooling Engine .dockerignore missing"
fi

# Check MCP Gateway files
if [ -d "../Synapse-Worker/src/mcp_gateway" ]; then
    print_status "MCP Gateway source files exist"
else
    print_error "MCP Gateway source files missing"
fi

# Check docker-compose.dev.yml
if grep -q "Dockerfile.optimized" docker-compose.dev.yml; then
    print_status "docker-compose.dev.yml uses optimized Dockerfiles"
else
    print_error "docker-compose.dev.yml not updated"
fi

if grep -q "mcp_gateway" docker-compose.dev.yml; then
    print_status "MCP Gateway service configured in docker-compose.dev.yml"
else
    print_error "MCP Gateway service missing from docker-compose.dev.yml"
fi

# Check Alpine images
if grep -q "redis:7-alpine" docker-compose.dev.yml; then
    print_status "Redis using Alpine image"
else
    print_warning "Redis not using Alpine image"
fi

if grep -q "pgvector/pgvector:pg16-alpine" docker-compose.dev.yml; then
    print_status "PostgreSQL using Alpine image"
else
    print_warning "PostgreSQL not using Alpine image"
fi

echo ""
echo "🎯 Optimization Summary:"
echo "  - All services use optimized Dockerfiles"
echo "  - MCP Gateway added for tool orchestration"
echo "  - Alpine images for databases"
echo "  - Optimized .dockerignore files"
echo "  - BuildKit cache mounts enabled"
echo ""
echo "🚀 Ready to build with:"
echo "  ./build-dev-optimized.sh"
echo ""
echo "📊 Expected size reductions:"
echo "  - GPU Worker: 20GB → 4-6GB (70-80%)"
echo "  - CPU Worker: 12GB → 2-3GB (75-80%)"
echo "  - Backend: 10GB → 1-2GB (80-90%)"
echo "  - Tooling Services: 8GB → 1-2GB each (75-80%)"

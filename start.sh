#!/usr/bin/env bash
# Ezkey Demo Device - Docker start (BuildKit + docker compose).
# Extra arguments are passed through (e.g. ./start.sh -d for detached).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ ! -f docker-compose.yml ]]; then
  echo "ERROR: docker-compose.yml not found. Run this from the repository root." >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker is not running or not installed." >&2
  exit 1
fi

export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

if docker compose version >/dev/null 2>&1; then
  DOCKER_COMPOSE=(docker compose)
else
  DOCKER_COMPOSE=(docker-compose)
fi

echo ""
echo "============================================"
echo "  Ezkey Demo Device - Docker"
echo "  BuildKit enabled | http://localhost:3080"
echo "============================================"
echo ""

exec "${DOCKER_COMPOSE[@]}" up --build "$@"

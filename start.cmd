@echo off
setlocal EnableExtensions
cd /d "%~dp0"

if not exist "docker-compose.yml" (
  echo ERROR: docker-compose.yml not found. Run this from the repository root.
  exit /b 1
)

where docker >nul 2>&1
if errorlevel 1 (
  echo ERROR: Docker is not installed or not on PATH.
  exit /b 1
)

set DOCKER_BUILDKIT=1
set COMPOSE_DOCKER_CLI_BUILD=1

echo.
echo ============================================
echo   Ezkey Demo Device - Docker
echo   BuildKit enabled ^| http://localhost:3080
echo ============================================
echo.

docker compose up --build %*
exit /b %ERRORLEVEL%

# Ezkey Demo Device - Docker start (BuildKit + docker compose).
# Usage: .\start.ps1 [-Detach] [-NoCache]
#   -Detach: run containers in the background (docker compose up -d).
#   -NoCache: pass --no-cache to the build step.

param(
    [switch]$Detach,
    [switch]$NoCache
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

if (-not (Test-Path (Join-Path $Root "docker-compose.yml"))) {
    Write-Host "ERROR: docker-compose.yml not found. Run this from the repository root." -ForegroundColor Red
    exit 1
}

docker info 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Docker is not running or not installed." -ForegroundColor Red
    exit 1
}

$useComposeV2 = $false
docker compose version 2>$null | Out-Null
if ($LASTEXITCODE -eq 0) {
    $useComposeV2 = $true
}

$env:DOCKER_BUILDKIT = "1"
$env:COMPOSE_DOCKER_CLI_BUILD = "1"

Write-Host ""
Write-Host "============================================"
Write-Host "  Ezkey Demo Device - Docker"
Write-Host "  BuildKit enabled | http://localhost:3080"
Write-Host "============================================"
Write-Host ""

if ($useComposeV2) {
    $composeArgs = @("compose", "up", "--build")
    if ($NoCache) {
        $composeArgs += "--no-cache"
    }
    if ($Detach) {
        $composeArgs += "-d"
    }
    & docker $composeArgs
} else {
    $legacyArgs = @("up", "--build")
    if ($NoCache) {
        $legacyArgs += "--no-cache"
    }
    if ($Detach) {
        $legacyArgs += "-d"
    }
    & docker-compose $legacyArgs
}
exit $LASTEXITCODE

@echo off
title PulseCore Backend (API - port 5000)
set "ROOT=%~dp0"
set "ROOT=%ROOT:~0,-1%"
cd /d "%ROOT%"
if not exist "backend\PulseCore.Api\PulseCore.Api.csproj" (
  echo  ERROR: backend folder or project not found.
  echo  Run this script from the project root: %ROOT%
  pause
  exit /b 1
)
cd /d "%ROOT%\backend"
echo.
echo  PulseCore Backend API - port 5000
echo  ==================================
echo  API:     http://localhost:5000
echo  Swagger: http://localhost:5000/swagger
echo  Health:  http://localhost:5000/health
echo.
REM Free port 5000 and stop any existing API process so build can run
powershell -NoProfile -Command "$c = Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue; if ($c) { $c | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }; Write-Host '  Stopped previous API on port 5000.' }"
echo.
echo  Starting API... Press Ctrl+C to stop.
echo.
dotnet run --project PulseCore.Api\PulseCore.Api.csproj
if errorlevel 1 (
  echo.
  echo  API failed to start.
  echo  If "address already in use" or "port 5000": run free-port-5000.cmd then try again.
  echo  Otherwise check .NET SDK: dotnet --version
  echo.
)
pause

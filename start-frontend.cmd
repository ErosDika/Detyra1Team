@echo off
title PulseCore Frontend (Next.js)
cd /d "%~dp0"
REM Frontend = port 3000 only. Run this from PROJECT ROOT (folder with package.json), not from backend.

where node >nul 2>nul || (
  echo.
  echo   Node.js is not installed or not in PATH.
  echo   Install it from: https://nodejs.org ^(choose LTS^)
  echo   Then close ALL Command Prompt windows and run this again.
  echo.
  start https://nodejs.org
  pause
  exit /b 1
)

if not exist ".env.local" (
  echo Creating .env.local from .env.example so frontend uses the API...
  copy .env.example .env.local >nul
  echo.
)

if not exist node_modules (
  echo Installing dependencies first (may take a minute)...
  call npm install
  echo.
)
echo.
echo  PulseCore Frontend - Next.js (port 3000 only)
echo  ============================================
echo  URL: http://localhost:3000
echo  Run this from PROJECT ROOT (folder with package.json), NOT from the backend folder.
echo.
echo  If you see "EADDRINUSE" or "port 3000 already in use":
echo  - Another frontend or Node process is using 3000. Run free-port-3000.cmd to free it, then run this again.
echo  - Or close the other Command Prompt window where npm run dev is running.
echo.
where pnpm >nul 2>nul && (pnpm run dev) || (npm run dev)
if errorlevel 1 (
  echo.
  echo  Failed. Port 3000 in use? Run free-port-3000.cmd then start-frontend.cmd again.
  echo.
)
pause

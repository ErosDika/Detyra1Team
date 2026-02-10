@echo off
title PulseCore Frontend (Next.js)
cd /d "%~dp0"

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

if not exist node_modules (
  echo Installing dependencies first...
  call npm install
  echo.
)
echo Starting frontend at http://localhost:3000 ...
echo Press Ctrl+C to stop.
where pnpm >nul 2>nul && (pnpm run dev) || (npm run dev)
pause

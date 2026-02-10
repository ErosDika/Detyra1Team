@echo off
title PulseCore - Start Full App
cd /d "%~dp0"

echo.
echo  ========================================
echo   PulseCore HMS - Full App Launcher
echo  ========================================
echo.

REM Ensure frontend can talk to the API: copy .env.example to .env.local if missing
if not exist ".env.local" (
  echo [1/4] Creating .env.local from .env.example so frontend uses the API...
  copy .env.example .env.local >nul
  echo        Done. Frontend will use http://localhost:5000 for the API.
) else (
  echo [1/4] .env.local exists - frontend will use your API URL.
)
echo.

REM Start backend in a new window
echo [2/4] Starting Backend (API) in a new window...
start "PulseCore Backend (API)" cmd /k "cd /d ""%~dp0backend"" && echo. && echo API: http://localhost:5000 && echo Swagger: http://localhost:5000/swagger && echo Health: http://localhost:5000/health && echo. && dotnet run --project PulseCore.Api"
echo        Backend window opened. Waiting for API to be ready...
echo.

REM Wait for API to respond (poll /health up to 30 seconds)
set "API_OK=0"
for /L %%i in (1,1,15) do (
  timeout /t 2 /nobreak >nul
  powershell -NoProfile -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:5000/health' -UseBasicParsing -TimeoutSec 3; exit 0 } catch { exit 1 }" 2>nul && set "API_OK=1" && goto :api_ready
)
:api_ready
if "%API_OK%"=="1" (
  echo [3/4] API is up. Health check passed.
) else (
  echo [3/4] API not responding yet. Frontend will still start; use mock data or try again in a moment.
)
echo.

REM Start frontend in another new window
echo [4/4] Starting Frontend (Next.js) in a new window...
if not exist "node_modules" (
  echo        Installing dependencies first...
  call npm install
  echo.
)
start "PulseCore Frontend (Next.js)" cmd /k "cd /d ""%~dp0"" && (where pnpm >nul 2>nul && pnpm run dev || npm run dev)"
echo        Frontend window opened.
echo.

REM Open browser after frontend has time to compile
echo Waiting for frontend to be ready, then opening browser...
timeout /t 10 /nobreak >nul
start http://localhost:3000 2>nul

echo.
echo  ========================================
echo   App is running
echo  ========================================
echo   Frontend:  http://localhost:3000
echo   Login:     http://localhost:3000/login
echo   Backend:   http://localhost:5000
echo   Swagger:   http://localhost:5000/swagger
echo   Health:    http://localhost:5000/health
echo  ========================================
echo.
echo To stop: close the "PulseCore Backend" and "PulseCore Frontend" windows (or Ctrl+C in each).
echo.
pause

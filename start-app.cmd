@echo off
title PulseCore - Start Full App
cd /d "%~dp0"

echo.
echo  ========================================
echo   PulseCore HMS - Full App Launcher
echo  ========================================
echo.

REM Ensure .env.local so frontend (3000) talks to backend (5000)
if not exist ".env.local" (
  echo [1/5] Creating .env.local from .env.example...
  copy .env.example .env.local >nul
  echo        Done. Frontend will use backend at http://localhost:5000.
) else (
  echo [1/5] .env.local exists - frontend 3000, backend 5000.
)
echo.

REM Start backend in a new window (API creates/updates DB on startup: PulseCore_New or SQLite)
echo [2/5] Starting Backend (API) in a new window...
echo        API runs on port 5000, uses SQLite by default ^(no SQL Server needed^).
start "PulseCore Backend (API)" cmd /k "cd /d ""%~dp0backend"" && echo. && echo Backend API - port 5000 && echo API: http://localhost:5000 && echo Swagger: http://localhost:5000/swagger && echo Health: http://localhost:5000/health && echo. && dotnet run --project PulseCore.Api"
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
  echo [3/5] API is up. Health check passed.
) else (
  echo [3/5] API not responding yet. Frontend will still start; use mock data or try again in a moment.
)
echo.

REM Start frontend in another new window
echo [4/5] Starting Frontend (Next.js) in a new window...
if not exist "node_modules" (
  echo        Installing dependencies first (this may take a minute)...
  call npm install
  echo.
)
start "PulseCore Frontend (Next.js)" cmd /k "cd /d ""%~dp0"" && echo Starting at http://localhost:3000 ... && (where pnpm >nul 2>nul && pnpm run dev || npm run dev)"
echo        Frontend window opened. First run may take 15-30 seconds to compile.
echo.

REM Wait for frontend to be ready, then open browser (poll up to 45 seconds)
echo [5/5] Waiting for frontend to be ready, then opening browser...
set "FE_OK=0"
for /L %%j in (1,1,15) do (
  timeout /t 3 /nobreak >nul
  powershell -NoProfile -Command "try { $r = Invoke-WebRequest -Uri 'http://localhost:3000' -UseBasicParsing -TimeoutSec 5; exit 0 } catch { exit 1 }" 2>nul && set "FE_OK=1" && goto :fe_ready
)
:fe_ready
if "%FE_OK%"=="1" (
  start http://localhost:3000 2>nul
  echo        Frontend is up. Browser opened.
) else (
  echo        Frontend not ready yet. Open http://localhost:3000 in your browser in a moment.
  start http://localhost:3000 2>nul
)
echo.
echo  ========================================
echo   App is running
echo  ========================================
echo   Frontend: http://localhost:3000
echo   Login:    http://localhost:3000/login
echo   Backend:  http://localhost:5000
echo   Swagger:  http://localhost:5000/swagger
echo   Health:   http://localhost:5000/health
echo  ========================================
echo.
echo To stop: close the "PulseCore Backend" and "PulseCore Frontend" windows (or Ctrl+C in each).
echo.
pause

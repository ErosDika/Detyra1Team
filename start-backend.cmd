@echo off
title PulseCore Backend (API)
cd /d "%~dp0backend"
echo Starting API at http://localhost:5000 ...
echo Press Ctrl+C to stop.
dotnet run --project PulseCore.Api
pause

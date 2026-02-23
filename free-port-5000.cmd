@echo off
title Free port 5000
echo.
echo  Freeing port 5000 (backend API)...
echo.
powershell -NoProfile -Command "$c = Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue; if ($c) { $c | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }; echo Port 5000 freed. Run start-backend.cmd to start the API. } else { echo Port 5000 is already free. }"
echo.
pause

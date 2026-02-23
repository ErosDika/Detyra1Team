@echo off
title Free port 3000
echo.
echo  Checking what is using port 3000...
echo.
powershell -NoProfile -Command "$c = Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue; if ($c) { $c | ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }; echo 'Port 3000 freed. You can run start-frontend.cmd now.' } else { echo 'Port 3000 is already free.' }"
echo.
pause

@echo off
title PulseCore - Create/Update Database
cd /d "%~dp0"

echo.
echo  ========================================
echo   Create or update database (SQL Server)
echo  ========================================
echo.
echo  Uses connection string from appsettings.Development.json
echo  Default database name: PulseCore_New (created on first run).
echo.
echo  If LocalDB is not installed, set in appsettings.Development.json:
echo    "Database": { "Provider": "Sqlite" }
echo  Then run the API; it will create pulsecore.db in the API folder.
echo.

dotnet ef database update --project PulseCore.Infrastructure --startup-project PulseCore.Api
if %ERRORLEVEL% neq 0 (
  echo.
  echo  Migration failed. Try running the API instead - it will run migrations on startup.
  echo  Or use SQLite: set "Database": { "Provider": "Sqlite" } in appsettings.Development.json
  exit /b 1
)
echo.
echo  Database created/updated successfully.
exit /b 0

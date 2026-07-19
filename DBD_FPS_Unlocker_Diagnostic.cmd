@echo off
setlocal
title DBD FPS Unlocker v1.0.0 - Diagnostic
cd /d "%~dp0"

powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0DBD_FPS_Unlocker.ps1"
set "EXIT_CODE=%ERRORLEVEL%"

echo.
echo Exit code: %EXIT_CODE%
pause

endlocal
exit /b %EXIT_CODE%

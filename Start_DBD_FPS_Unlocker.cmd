@echo off
setlocal
title DBD FPS Unlocker v1.0.0
cd /d "%~dp0"

echo Starting DBD FPS Unlocker...
echo.
echo Security notes:
echo - No VBS is used.
echo - PowerShell is not hidden.
echo - Your Windows execution policy is NOT changed.
echo - Bypass applies only to this single PowerShell process.
echo.
echo You may minimize this console while the GUI is open.
echo.

powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -File "%~dp0DBD_FPS_Unlocker.ps1"
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" (
    echo.
    echo DBD FPS Unlocker could not start.
    echo Run DBD_FPS_Unlocker_Diagnostic.cmd and copy the full error.
    echo.
    pause
)

endlocal
exit /b %EXIT_CODE%

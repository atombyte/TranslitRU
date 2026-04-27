@echo off
setlocal EnableExtensions

set "APP=TranslitRU"
set "TARGET=%LOCALAPPDATA%\%APP%"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "STARTMENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs"

echo.
echo === Translit RU/DE Deinstallation ===
echo.

taskkill /F /IM %APP%.exe >nul 2>&1

del /Q "%STARTUP%\%APP%.lnk" >nul 2>&1
del /Q "%STARTMENU%\%APP%.lnk" >nul 2>&1
del /Q "%STARTMENU%\%APP% deinstallieren.lnk" >nul 2>&1

REM kurz warten, falls .exe noch Lock haelt
timeout /t 1 >nul

if exist "%TARGET%" (
    rmdir /S /Q "%TARGET%"
)

echo Deinstalliert.
echo.
timeout /t 3 >nul
exit /b 0

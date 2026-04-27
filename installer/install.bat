@echo off
setlocal EnableExtensions

set "APP=TranslitRU"
set "TARGET=%LOCALAPPDATA%\%APP%"
set "EXE=%TARGET%\%APP%.exe"
set "UNINST=%TARGET%\uninstall.bat"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "STARTMENU=%APPDATA%\Microsoft\Windows\Start Menu\Programs"

echo.
echo === Translit RU/DE Setup ===
echo.

REM laufende Instanz beenden
taskkill /F /IM %APP%.exe >nul 2>&1

if not exist "%TARGET%" mkdir "%TARGET%"
copy /Y "%~dp0%APP%.exe" "%EXE%" >nul
if errorlevel 1 (
    echo [Fehler] Kopieren fehlgeschlagen.
    pause
    exit /b 1
)
copy /Y "%~dp0uninstall.bat" "%UNINST%" >nul

REM Verknuepfungen anlegen
powershell -NoProfile -Command ^
  "$w=New-Object -COM WScript.Shell;" ^
  "$s=$w.CreateShortcut('%STARTUP%\%APP%.lnk');$s.TargetPath='%EXE%';$s.WorkingDirectory='%TARGET%';$s.Save();" ^
  "$s=$w.CreateShortcut('%STARTMENU%\%APP%.lnk');$s.TargetPath='%EXE%';$s.WorkingDirectory='%TARGET%';$s.Save();" ^
  "$s=$w.CreateShortcut('%STARTMENU%\%APP% deinstallieren.lnk');$s.TargetPath='%UNINST%';$s.WorkingDirectory='%TARGET%';$s.Save()"

REM starten
start "" "%EXE%"

echo.
echo Installiert nach:  %TARGET%
echo Autostart:         aktiv
echo Toggle-Hotkey:     Ctrl+Shift+Space
echo.
echo Tray-Icon erscheint rechts in Taskleiste.
echo.
timeout /t 4 >nul
exit /b 0

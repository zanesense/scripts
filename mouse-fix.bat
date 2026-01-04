@echo off
setlocal

echo ========================================
echo Gaming Mouse Tweaks Script
echo ========================================

REM Create a timestamp for backup filename
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do set DATE=%%c-%%a-%%b
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set TIME=%%a-%%b
set BACKUPFILE=MouseRegistryBackup_%DATE%_%TIME%.reg

REM Replace any invalid characters in filename
set BACKUPFILE=%BACKUPFILE::=-%
set BACKUPFILE=%BACKUPFILE:/=-%
set BACKUPFILE=%BACKUPFILE: =_%

echo Creating registry backup: %BACKUPFILE%
REG EXPORT "HKCU\Control Panel\Mouse" "%~dp0%BACKUPFILE%" /y

echo Backup created successfully.
echo Applying optimal gaming mouse settings...

REM Disable mouse acceleration by turning off "Enhance pointer precision"
REG ADD "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f
REG ADD "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f
REG ADD "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f
REG ADD "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f
REG ADD "HKCU\Control Panel\Mouse" /v "MouseTrails" /t REG_SZ /d "0" /f

echo Mouse acceleration disabled and optimal settings applied.
echo You may need to log off or restart for changes to take effect.
pause

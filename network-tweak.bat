@echo off
setlocal enabledelayedexpansion

:MENU
echo =======================================
echo Network Tweaks Script
echo =======================================
echo 1. Apply network tweaks
echo 2. Revert network tweaks to defaults
echo 3. Exit
echo =======================================
set /p choice=Enter your choice (1-3): 

if "%choice%"=="1" goto APPLY
if "%choice%"=="2" goto REVERT
if "%choice%"=="3" exit
echo Invalid choice. Please try again.
echo.
goto MENU

:APPLY
echo Applying network tweaks...

REM Disable TCP heuristics
netsh int tcp set heuristics disabled

REM Set congestion provider to CTCP
netsh int tcp set supplemental template=internet congestionprovider=ctcp

REM Enable RSS, ECN, Fast Open, and disable timestamps
netsh int tcp set global rss=enabled
netsh int tcp set global ecncapability=enabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global fastopenfallback=enabled

REM Set custom initial congestion window
netsh int tcp set supplemental template=custom icw=10

REM Loop through active interfaces and set MTU to 1500
for /f "tokens=1,2 delims=:" %%A in ('netsh interface show interface ^| findstr /R /C:"Connected"') do (
    set "iface=%%B"
    REM Remove leading space
    set iface=!iface:~1!
    echo Setting MTU 1500 for !iface!
    netsh interface ipv4 set subinterface "!iface!" mtu=1500 store=persistent
)

echo Network tweaks applied successfully.
pause
goto MENU

:REVERT
echo Reverting network tweaks to defaults...

REM Enable TCP heuristics
netsh int tcp set heuristics enabled

REM Set congestion provider to default
netsh int tcp set supplemental template=internet congestionprovider=default

REM Reset global TCP settings
netsh int tcp set global rss=default
netsh int tcp set global ecncapability=default
netsh int tcp set global timestamps=default
netsh int tcp set global fastopen=default
netsh int tcp set global fastopenfallback=default

REM Set custom initial congestion window back to default
netsh int tcp set supplemental template=custom icw=4

REM Loop through active interfaces and set MTU to 1500 (default)
for /f "tokens=1,2 delims=:" %%A in ('netsh interface show interface ^| findstr /R /C:"Connected"') do (
    set "iface=%%B"
    REM Remove leading space
    set iface=!iface:~1!
    echo Reverting MTU for !iface! to 1500
    netsh interface ipv4 set subinterface "!iface!" mtu=1500 store=persistent
)

echo Network tweaks reverted to defaults.
pause
goto MENU

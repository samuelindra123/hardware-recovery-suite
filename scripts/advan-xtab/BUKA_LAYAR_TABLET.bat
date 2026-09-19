@echo off
title BUKA LAYAR ADVAN XTAB (SCRCPY)
color 0B
cd /d C:\scrcpy\scrcpy-win64-v2.4

echo ========================================================
echo  MEMBUKA TAMPILAN ADVAN XTAB DI MONITOR LAPTOP...
echo ========================================================
echo.

scrcpy.exe --window-title "Advan XTab - Layar Virtual"

if %errorlevel% neq 0 (
    echo.
    echo ========================================================
    echo Gagal membuka layar. Pastikan kabel USB terhubung!
    echo ========================================================
    pause
)

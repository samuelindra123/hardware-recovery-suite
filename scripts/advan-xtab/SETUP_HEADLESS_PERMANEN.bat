@echo off
title SETUP HEADLESS PERMANEN (ADVAN XTAB) - SAMUEL INDRA BASTIAN
color 0E

echo ====================================================================
echo   KONFIGURASI HEADLESS PERMANEN (ANDROID 13 SDK 33)
echo   Developer: Samuel Indra Bastian (comdonate9@gmail.com)
echo ====================================================================
echo.

echo [*] Menyetel layar agar tidak pernah tidur saat dicolok charger...
adb shell "svc power stayon true"
adb shell "settings put global stay_on_while_plugged_in 3"

echo [*] Menyetel screen timeout maksimum (24.8 hari)...
adb shell "settings put system screen_off_timeout 2147483647"

echo [*] Menonaktifkan kunci layar (Lockscreen Disabled)...
adb shell "locksettings set-disabled true"
adb shell "settings put secure lockscreen.disabled 1"

echo [*] Mengaktifkan Wireless ADB Port 5555...
adb tcpip 5555

echo.
echo ====================================================================
echo [SELESAI] Konfigurasi Headless Sukses Diterapkan!
echo ====================================================================
pause

@echo off
title AKTIFKAN KONTROL ANYDESK & BYPASS TAPJACKING - SAMUEL INDRA BASTIAN
color 0C

echo ====================================================================
echo   AKTIVASI REMOTE KONTROL ANYDESK AD1 & BYPASS SISTEM ANDROID 13
echo   Developer: Samuel Indra Bastian (comdonate9@gmail.com)
echo ====================================================================
echo.

echo [*] Mengaktifkan Layanan Aksesibilitas AnyDesk AD1...
adb shell "settings put secure enabled_accessibility_services com.anydesk.adcontrol.ad1/com.anydesk.adcontrol.AccService"
adb shell "settings put secure accessibility_enabled 1"

echo [*] Menerapkan Bypass Tapjacking (Perekaman Layar Tanpa Konfirmasi Ulang)...
adb shell "appops set com.anydesk.anydeskandroid PROJECT_MEDIA allow"

echo [*] Mengizinkan Gambar di Atas Aplikasi Lain (SYSTEM_ALERT_WINDOW)...
adb shell "appops set com.anydesk.anydeskandroid SYSTEM_ALERT_WINDOW allow"
adb shell "appops set com.anydesk.adcontrol.ad1 SYSTEM_ALERT_WINDOW allow"

echo [*] Mendaftarkan ke Whitelist Baterai (Mencegah Aplikasi Ditutup Sistem)...
adb shell "dumpsys deviceidle whitelist +com.anydesk.anydeskandroid"
adb shell "dumpsys deviceidle whitelist +com.anydesk.adcontrol.ad1"

echo.
echo ====================================================================
echo [SELESAI] Izin Kontrol Penuh AnyDesk Berhasil Diaktifkan!
echo ====================================================================
pause

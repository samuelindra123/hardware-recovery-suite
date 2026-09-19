@echo off
title PULIHKAN KUNCI ADB (RESTORE ADB KEYS) - SAMUEL INDRA BASTIAN
color 0A

echo ====================================================================
echo   RESTORE OTOMATIS KUNCI IDENTITAS ADB (ADVAN XTAB)
echo   Developer: Samuel Indra Bastian (comdonate9@gmail.com)
echo ====================================================================
echo.

set TARGET_DIR=%USERPROFILE%\.android

if not exist "%TARGET_DIR%" (
    echo [*] Membuat direktori %TARGET_DIR%...
    mkdir "%TARGET_DIR%"
)

echo [*] Menyalin file kunci adbkey dan adbkey.pub...
copy /Y "%~dp0adbkey" "%TARGET_DIR%\adbkey"
copy /Y "%~dp0adbkey.pub" "%TARGET_DIR%\adbkey.pub"

echo.
if %errorlevel% equ 0 (
    echo [OK] Kunci identitas ADB berhasil dipulihkan!
    echo [OK] Laptop baru ini sekarang sudah resmi dikenali oleh Advan XTab.
    echo      Anda bisa langsung colok kabel atau akses wireless tanpa konfirmasi layar!
) else (
    echo [GAGAL] Terjadi kesalahan saat menyalin kunci. Pastikan dijalankan sebagai user normal.
)

echo.
echo ====================================================================
pause

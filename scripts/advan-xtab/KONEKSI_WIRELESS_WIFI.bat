@echo off
title KONEKSI SCRCPY WIRELESS (TANPA KABEL) - SAMUEL INDRA BASTIAN
color 0B

echo ====================================================================
echo   BUKA LAYAR ADVAN XTAB NIRKABEL (WIRELESS WI-FI)
echo   Developer: Samuel Indra Bastian (comdonate9@gmail.com)
echo ====================================================================
echo.
echo Pastikan laptop dan tablet berada dalam satu jaringan Wi-Fi rumah!
echo.

set TABLET_IP=192.168.1.15
set PORT=5555

set /p USER_IP="Masukkan IP Tablet [Tekan ENTER jika tetap %TABLET_IP%]: "
if not "%USER_IP%"=="" set TABLET_IP=%USER_IP%

echo.
echo [*] Menyambungkan ke %TABLET_IP%:%PORT%...
adb connect %TABLET_IP%:%PORT%

echo.
echo [*] Membuka layar scrcpy nirkabel...
scrcpy -s %TABLET_IP%:%PORT% --window-title "Advan XTab - Wireless Screen"

if %errorlevel% neq 0 (
    echo.
    echo ====================================================================
    echo [GAGAL] Tidak dapat terhubung ke tablet secara wireless.
    echo 1. Pastikan tablet dalam keadaan hidup dan terhubung ke Wi-Fi.
    echo 2. Cek apakah IP tablet berubah di router Anda.
    echo 3. Jika baru restart total, sambungkan USB sekali untuk mengaktifkan 'adb tcpip 5555'.
    echo ====================================================================
    pause
)

@echo off
title KLIK IZINKAN PERMANEN (SCRCPY OTG)
color 0E
cd /d C:\scrcpy\scrcpy-win64-v2.4

echo ========================================================
echo  MODUS OTG KEYBOARD AKTIF!
echo ========================================================
echo.
echo CARA KLIK "SELALU IZINKAN" DI LAYAR GELAP:
echo.
echo 1. Nanti akan muncul jendela kecil scrcpy di laptopmu.
echo 2. KLIK jendela kecil itu pakai mouse laptopmu.
echo 3. Sekarang tekan tombol ini di keyboard laptop berurutan:
echo.
echo      [TAB]   -> Fokus ke kotak "Selalu izinkan"
echo      [SPASI] -> Mencentang kotak permanen
echo      [TAB]   -> Geser ke tombol "OK / Izinkan"
echo      [ENTER] -> KLIK OK!
echo.
echo 4. Setelah itu tutup jendela ini, dan buka:
echo    BUKA_LAYAR_TABLET.bat
echo ========================================================
echo.
echo Menjalankan scrcpy OTG...
scrcpy.exe --otg
pause

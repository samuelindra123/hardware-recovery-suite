@echo off
title DUMP PRELOADER DARI MESIN (MTKCLIENT)
color 0E
cd /d C:\Users\Administrator\Downloads\mtkclient
echo ========================================================
echo   LANGKAH:
echo   1. Cabut kabel USB dari laptop
echo   2. Jalankan file ini
echo   3. Colok kabel USB ke laptop
echo ========================================================
echo.
python mtk.py dumppreloader
echo.
pause

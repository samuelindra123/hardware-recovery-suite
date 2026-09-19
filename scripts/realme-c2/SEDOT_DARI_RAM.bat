@echo off
title SEDOT DARI RAM OTOMATIS (MTKCLIENT)
color 0B
cd /d C:\Users\Administrator\Downloads\mtkclient
echo ========================================================
echo   MODE SAKTI: DUMP PRELOADER OTOMATIS DARI RAM CHIP
echo   (Tanpa preloader luar, membaca konfigurasi bawaan pabrik)
echo ========================================================
echo.
python mtk.py printgpt --write_preloader_to_file
echo.
pause

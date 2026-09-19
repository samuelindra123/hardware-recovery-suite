@echo off
title REALME C2 (cereus) - BACA GPT
color 0A
cd /d C:\Users\Administrator\Downloads\mtkclient

echo ========================================================
echo  REALME C2 (cereus) - DIRECT DRAM BYPASS DA1
echo ========================================================
echo.
echo LANGKAH:
echo   1. Pastikan board sudah dipasang power 4.4V + elco
echo   2. Cabut USB dari laptop
echo   3. File ini sudah berjalan, sekarang colok USB ke board
echo ========================================================
echo.

python mtk.py printgpt --preloader mtkclient/Loader/Preloader/0766_preloader_cereus_3C2D76D046.bin

echo.
echo ========================================================
echo SELESAI - cek output di atas!
echo Copy paste output ke chat AI!
echo ========================================================
pause


@echo off
title BACA PARTISI OPPO A1K - COBA SEMUA PRELOADER MT6762/MT6765
color 0A
cd /d C:\Users\Administrator\Downloads\mtkclient

echo ========================================================
echo   COBA PRELOADER 1: oppo6762_18540 (sama model HP)
echo ========================================================
python mtk.py printgpt --preloader mtkclient/Loader/Preloader/preloader_oppo6762_18540.bin
echo.
pause

echo ========================================================
echo   COBA PRELOADER 2: oppo6762_18540_98711A09AB (versi lain)
echo ========================================================
python mtk.py printgpt --preloader mtkclient/Loader/Preloader/preloader_oppo6762_18540_98711A09AB.bin
echo.
pause

echo ========================================================
echo   COBA PRELOADER 3: 0766_oppo6765_19451
echo ========================================================
python mtk.py printgpt --preloader mtkclient/Loader/Preloader/0766_preloader_oppo6765_19451_94B0482E99.bin
echo.
pause

echo ========================================================
echo   COBA PRELOADER 4: oppo6765_19451
echo ========================================================
python mtk.py printgpt --preloader mtkclient/Loader/Preloader/preloader_oppo6765_19451_94B0482E99.bin
echo.
pause

echo ========================================================
echo   COBA PRELOADER 5: Vivo_6762_Y8X (chipset MT6762)
echo ========================================================
python mtk.py printgpt --preloader mtkclient/Loader/Preloader/preloader_Vivo_6762_Y8X_k62v1_64_bsp.bin
echo.
pause

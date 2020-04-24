@Echo off
title Creating SCPrompt Package, using IExpress method
cls
echo this script will create the SCPrompt package using IExpress on WinXP, Vista & likely Win7.
echo.
echo consult the VNC2Me website for further information
echo before running for the first time, you need to edit the SED file:
echo ./build_resources/SCPrompt.SED.
echo
echo.
echo if you do not want to build this package now,
echo      press ctrl + c NOW
echo.
echo else,

pause
cls


iexpress.exe /N ./build_resources/SCPrompt.SED
echo.
echo VNC2Me_iexpress.exe building complete.
echo.
echo If unsucessful check "usage of iexpress.exe in Windows" on Google or other search engines.
echo.
pause

@echo off
title Creating VNC2Me Package, using 7zip Batch File
cls
echo this script will create the VNC2Me package using 7zip method.
echo.
echo This method should be used as a 'Last Resort' if the 'Build_SCPrompt_7zip.exe' Application fails to build the necesary file
echo.
echo consult the readme or website before running for the first time.
echo.
echo if you do not want to build this package now,
echo      press ctrl + c NOW
echo.
echo else,

pause
rem cls
del temp\V2M_Prompt.7z
del temp\V2M_Prompt.exe
del VNC2Me_SC_7zip.exe

build_resources\7za a temp\V2M_Prompt.7z scprompt\*.*
copy /b build_resources\7z_v2m.sfx + build_resources\7z_sfx_config.txt + temp\V2M_Prompt.7z temp\V2M_Prompt.exe

build_resources\upx -9 -f -k -o VNC2Me_SC_7zip.exe temp\V2M_Prompt.exe

rem copy temp\V2M_Prompt.exe .\ /y
rem copy temp\V2M_Prompt.exe "%HOMEDRIVE%%HOMEPATH%\desktop" /y
rem echo VNC2Me_quick.exe has been placed on your desktop ...
echo VNC2Me_SC_7zip.exe has been created in the same directory as this batch file.
echo it is compressed with UPX.
echo temp directory contains V2M_Prompt.exe file which is uncompressed.
echo.
pause

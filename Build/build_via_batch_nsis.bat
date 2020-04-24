@echo off
title Creating SCPrompt Package, using NSIS method
cls
echo This script will create the SCPrompt package using NSIS
echo on WinXP, Vista ^& likely Win7.
echo.
echo Consult the SCPrompt website for further information.
echo Before running for the first time, you need to edit the NSI file:
echo .\build_resources\SCPrompt.NSI.
echo.
echo.
echo If you do not want to build this package now,
echo      press ctrl + c NOW
echo.
echo otherwise,

pause
cls
echo Building started...
echo.

set error=
.\build_resources\makensis.exe /V2 .\build_resources\scprompt.nsi
ECHO Returned Errorlevel was: %ERRORLEVEL%

if "%ERRORLEVEL%"=="" goto :NOERROR
if "%ERRORLEVEL%"=="0" goto :NOERROR
rem else if errorlevel is something else, we had a problem ...
:ERROR
echo.
echo ***************************
title ERROR Creating SCPrompt Package
echo.
echo SCPrompt building Appears to have failed.
echo.
echo Please check the error messages above, then
echo check "usage of makensis.exe in Windows" via a search engine.
echo.
goto EOF
:NOERROR
echo.
echo ***************************
title Success Creating SCPrompt Package
echo.
echo SCPrompt building complete.
echo.
echo Enjoy and please link to us, spread the joy.
echo.
:EOF
pause
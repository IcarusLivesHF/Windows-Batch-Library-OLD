@echo off & setlocal enableDelayedExpansion

set "revisionRequired=3.26"
set  "openLib=(ren "%~nx0" temp.bat & ren "Library.bat" "%~nx0""
set "closeLib=ren "%~nx0" "Library.bat" & ren temp.bat "%~nx0")" & set "self=%~nx0"
(2>nul %openLib% && ( call :revision ) || ( ren temp.bat "%~nx0" & echo Library.bat Required & timeout /t 3 & exit))
	call :stdlib 100 100
	call :macros
%closeLib%  && ( cls & goto :setup)
:setup

set "url=https://www.nirsoft.net/utils/nircmd-x64.zip"
set "file=nircmd.zip"

%download% %url% %file%
%unZIP% nircmd

del /f /q NirCmd.chm
del /f /q NirCmd.zip
del /f /q NirCmdc.exe

move /-y NirCmd.exe "%temp%"

echo NirCmd Successfully installed in:
echo.
echo %temp%
timeout /t 5
exit


pause

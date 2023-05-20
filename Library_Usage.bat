@echo off & setlocal enableDelayedExpansion & set "(=(ren "%~nx0" -t.bat & ren "Library.bat" "%~nx0"" & set ")=ren "%~nx0" "Library.bat" & ren -t.bat "%~nx0")" & set "self=%~nx0" & set "failLib=ren -t.bat "%~nx0" &echo Library not found & timeout /t 3 /nobreak & exit"

%(% && (call :revision 4.1.0)||(%failLib%)
	call :stdlib
%)%

pause

@echo off & setlocal enableDelayedExpansion & set "(=(set "\=?" & ren "%~nx0" -t.bat & ren "?.bat" "%~nx0"" & set ")=ren "%~nx0" "^^!\^^!.bat" & ren -t.bat "%~nx0")" & set "self=%~nx0" & set "failedLibrary=ren -t.bat "%~nx0" &echo Library not found & timeout /t 3 & exit"

set "revisionRequired=3.30.1"
(%(:?=Library% && (call :revision)||(%failedLibrary%))2>nul
	call :stdlib /w:150 /h:20 /title:"My title" /fs:18 /rgb:"0;0;0":"255;255;255"
	call :math
	call :misc
	call :shapes
	call :algorithmicConditions
	call :turtleFunctions
	call :colorRange
	call :macros
	rem etc...
%)%  && (cls&goto :setup)
:setup

rem stdLib arguments can be in any order

rem PLEASE NOTE: You do NOT have to call all of the functions above, you can call whichever ones you need to keep the variable environment low
rem YOUR CODE GOES HERE

pause & exit

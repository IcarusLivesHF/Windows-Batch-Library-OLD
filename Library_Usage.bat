@echo off & setlocal enableDelayedExpansion

set "revisionRequired=3.29.2"
set  "import(=(set "\i=?" & ren "%~nx0" -t.bat & ren "?.bat" "%~nx0""
set ")=ren "%~nx0" "^^!\i^^!.bat" & ren -t.bat "%~nx0")" & set "self=%~nx0"
set "failedLibrary=ren -t.bat "%~nx0" ^&echo  Missing Library. Required Revision:%revisionRequired% ^& timeout /t 3 ^& exit"
(2>nul %import(:?=Library% && ( call :revision ) || ( %failedLibrary% ))
	call :stdlib /w:50 /h:20 /fs:12 /title:"My Title" /rgb:"255;255;255":"255;0;0" /c
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

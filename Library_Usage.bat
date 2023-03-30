@echo off & setlocal enableDelayedExpansion & set "(=(set "\=?" & ren "%~nx0" -t.bat & ren "?.bat" "%~nx0"" & set ")=ren "%~nx0" "^^!\^^!.bat" & ren -t.bat "%~nx0")" & set "self=%~nx0" & set "failedLibrary=ren -t.bat "%~nx0" &echo Library not found & timeout /t 3 & exit"

set "revisionRequired=4.0.0"
(%(:?=Library% && (call :revision)||(%failedLibrary%))2>nul
	call :StdLib /w:N /h:N /fs:N /title:"foobar" /rgb:"foo":"bar" /debug /extlib /3rdparty /multi /sprite /math /misc /shape /ac /turtle /cursor /cr:N /gfx /util
%)%  && (cls&goto :setup)
:setup

rem YOUR CODE GOES HERE
pause & exit

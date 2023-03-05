@echo off & setlocal enableDelayedExpansion

set  "openLib=( set "_c=?" & ren "%~nx0" _o.bat & ren "?.bat" "%~nx0""
set "closeLib=ren "%~nx0" "^^!_c^^!.bat" & ren _o.bat "%~nx0" )"

rem PLEASE NOTE: You do NOT have to use ALL of the 'call' commands listed below, you may use whichever one you find necessary.
%openLib:?=Library%
	call :StdLib 100 100
	call :ExtLib
	call :math
	call :misc
	call :shapes
	call :algorithmicConditions
	call :turtleFunctions
	call :colorRange
	call :macros
%closeLib%  && ( cls & goto :setup) || ( Echo Something went wrong.. & pause & exit )
:setup

rem you can begin writing ALL of your code HERE.

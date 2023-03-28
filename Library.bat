(call :buildSketch) & exit
:revision DONT CALL
	set "revision=3.30.2"
	set "libraryError=False"
	for /f "tokens=4-5 delims=. " %%i in ('ver') do set "winVERSION=%%i.%%j"
	if %revision:.=% lss %revisionRequired:.=% (
		echo Updated Library.bat Required
		set "libraryError=True"
	)
	if "%winversion%" neq "10.0" (
		echo %~n0 is not supported on this version of Windows: %winVERSION%"
		set "libraryError=True"
	)
	if "%libraryError%" equ "True" (
		ren "%~nx0" "Library.bat"
		ren "temp.bat" "%self%"
		del /f /q "temp.bat"
		timeout /t 3 & exit
	)
goto :eof
:StdLib %~1=wid %~2=hei %~3=fontSize %~3=/debug
title Powered by: Windows Batch Library - Revision: %Revision%
set "defaultFontSize=12"
set "debug=False"
set "clearEnvironment=False"
set "providedColorArguments=False"
set "extendedLibrary=False"
set "getThirdParty=False"
set "multiThreaded=False"
set "pixel=л"
set ".=л"
set "esc="
(for /f %%a in ('echo prompt $E^| cmd') do set "esc=%%a" )
set "\e=%esc%["
set "\p=echo %esc%["
set "\rgb=38;2;^!r^!;^!g^!;^!b^!m"
set "\fcol=48;2;^!r^!;^!g^!;^!b^!m"
set "cls=%esc%[2J"
set "\c=%esc%[2J"
<nul set /p "=%esc%[?25l"
rem newLine
(set \n=^^^
%= This creates an escaped Line Feed - DO NOT ALTER =%
)

for %%a in (%*) do (
	set /a "totalArguemnts+=1"
	set "fullArgument=%%a"
	for /f "tokens=1-3 delims=:" %%i in ("!fullArgument:~1!") do (
		set "argumentCommand[!totalArguemnts!]=%%~i"
		set "argumentArgument[!totalArguemnts!][1]=%%~j"
		set "argumentArgument[!totalArguemnts!][2]=%%~k"
	)
)
for /l %%i in (1,1,%totalArguemnts%) do (

		   if /i "!argumentCommand[%%i]!" equ "w" (
			set /a "wid=width=!argumentArgument[%%i][1]!"
	) else if /i "!argumentCommand[%%i]!" equ "h" (
			set /a "hei=height=!argumentArgument[%%i][1]!"
	) else if /i "!argumentCommand[%%i]!" equ "fs" (
			set /a "defaultFontSize=!argumentArgument[%%i][1]!"
	) else if /i "!argumentCommand[%%i]!" equ "title" (
			title !argumentArgument[%%i][1]!
			set "title=!argumentArgument[%%i][1]!"
	) else if /i "!argumentCommand[%%i]!" equ "rgb" (
			set "providedColorArguments=True"
			set "backgroundColor=!argumentArgument[%%i][1]!"
			set "textColor=!argumentArgument[%%i][2]!"
	) else if /i "!argumentCommand[%%i]!" equ "debug" (
			set "debug=True"
	) else if /i "!argumentCommand[%%i]!" equ "extLib" (
			set "extendedLibrary=True"
	) else if /i "!argumentCommand[%%i]!" equ "3rdparty" (
			set "getThirdParty=True"
	) else if /i "!argumentCommand[%%i]!" equ "multi" (
			set "multiThreaded=True"
	)
	set "argumentCommand[%%i]="
	set "argumentCommand[%%i][1]="
	set "argumentCommand[%%i][2]="
)


if "%debug%" neq "False" (
	@echo on
	call :setfont 16 Consolas
	mode 180,100
) else (
	if not defined wid set /a "wid=width=hei=height"
	if not defined hei set /a "hei=height=wid=width"
	call :setfont %defaultFontSize% Terminal
	mode !wid!,!hei!
)

if "!providedColorArguments!" neq "False" (
	if "!textColor:;=!" neq "!textColor!" (
		set "defaultStyle=2" 
	) else (
		set "defaultStyle=5"
	)
	<nul set /p "=%esc%[48;!defaultStyle!;%backgroundColor%m%esc%[38;!defaultStyle!;%textColor%m"
)

if "!extendedLibrary!" neq "False" (
	rem Backspace
	for /f %%a in ('"prompt $H&for %%b in (1) do rem"') do set "BS=%%a"
	rem BEL (sound)
	for /f %%i in ('forfiles /m "%~nx0" /c "cmd /c echo 0x07"') do set "BEL=%%i"
	rem Carriage Return
	for /f %%A in ('copy /z "%~dpf0" nul') do set "CR=%%A"
	rem Tab 0x09
	for /f "delims=" %%T in ('forfiles /p "%~dp0." /m "%~nx0" /c "cmd /c echo(0x09"') do set "TAB=%%T"
)

if "!getThirdParty!" neq "False" (
	call :get_Batch_3rdParty_Tools
)
if "!multiThreaded!" neq "False" (
	call :multithreadedFunctions
)
goto :eof

:setFont DONT CALL
if "%~2" equ "" goto :eof
call :init_setfont
%setFont% %~1 %~2
goto :eof

:cursor
set ">=<nul set /p ="
set "push=%esc%7"
set "pop=%esc%8"
set "cursor[U]=%esc%[?A"
set "cursor[D]=%esc%[?B"
set "cursor[L]=%esc%[?D"
set "cursor[R]=%esc%[?C"
set "colorText=%esc%[38;^!style^!;?m"
set "colorBack=%esc%[48;^!style^!;?m"
set "cac=%esc%[1J"
set "cbc=%esc%[0J"
set "underLine=%esc%[4m"
set "capIt=%esc%[0m"
set "moveXY=%esc%[^!y^!;^!x^!H"
set "home=%esc%[H"
set "setDefaultColor=<nul set /p "=%esc%[48;%defaultStyle%;%backgroundColor%m%esc%[38;%defaultStyle%;%textColor%m""
set setStyle=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1" %%1 in ("^!args^!") do (%\n%
	if /i "%%~1" equ "rgb" (%\n%
		set "style=2"%\n%
	) else if /i "%%~1" equ "bit" (%\n%
		set "style=5"%\n%
	)%\n%
)) else set args=
if defined defaultStyle (
	set "setDefaultColor=<nul set /p "=%esc%[48;%defaultStyle%;%backgroundColor%m%esc%[38;%defaultStyle%;%textColor%m""
)
goto :eof
:math
set /a "PI=(35500000/113+5)/10, HALF_PI=(35500000/113/2+5)/10, TWO_PI=2*PI, PI32=PI+HALF_PI, neg_PI=PI * -1, neg_HALF_PI=HALF_PI *-1"
set "_SIN=a-a*a/1920*a/312500+a*a/1920*a/15625*a/15625*a/2560000-a*a/1875*a/15360*a/15625*a/15625*a/16000*a/44800000"
set "sin=(a=(x * 31416 / 180)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), %_SIN%) / 10000"
set "cos=(a=(15708 - x * 31416 / 180)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), %_SIN%) / 10000"
set "sinr=(a=(x)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), %_SIN%) / 10000"
set "cosr=(a=(15708 - x)%%62832, c=(a>>31|1)*a, a-=(((c-47125)>>31)+1)*((a>>31|1)*62832)  +  (-((c-47125)>>31))*( (((c-15709)>>31)+1)*(-(a>>31|1)*31416+2*a)  ), %_SIN%) / 10000"
set "Sqrt(N)=( x=(N)/(11*1024)+40, x=((N)/x+x)/2, x=((N)/x+x)/2, x=((N)/x+x)/2, x=((N)/x+x)/2, x=((N)/x+x)/2 )"
set "Sign=1 / (x & 1)"
set "Abs=(((x)>>31|1)*(x))"
set "dist(x2,x1,y2,y1)=( @=x2-x1, $=y2-y1, ?=(((@>>31|1)*@-(($>>31|1)*$))>>31)+1, ?*(2*(@>>31|1)*@-($>>31|1)*$-((@>>31|1)*@-($>>31|1)*$)) + ^^^!?*((@>>31|1)*@-($>>31|1)*$-((@>>31|1)*@-($>>31|1)*$*2)) )"
set "avg=(x&y)+(x^y)/2"
set "map=(c)+((d)-(c))*((v)-(a))/((b)-(a))"
set "lerp=?=(a+c*(b-a)*10)/1000+a"
set "swap=t=x, x=y, y=t"
set "getState=a*8+b*4+c*2+d*1"
set "max=(((((y-x)>>31)&1)*x)|((~(((y-x)>>31)&1)&1)*y))"
set "min=(((((x-y)>>31)&1)*x)|((~(((x-y)>>31)&1)&1)*y))"
set "percentOf=p=x*y/100"
goto :eof
:misc
set "gravity=_G_=1, ?.acceleration+=_G_, ?.velocity+=?.acceleration, ?.acceleration*=0, ?+=?.velocity"
set "chance=1/((((^!random^!%%100)-x)>>31)&1)"
set "every=1/(((~(0-(frameCount%%x))>>31)&1)&((~((frameCount%%x)-0)>>31)&1))"
set "smoothStep=(3*100 - 2 * x) * x/100 * x/100"
set "bitColor=C=((r)*6/256)*36+((g)*6/256)*6+((b)*6/256)+16"
set "loop=for /l %%# in () do "
set "throttle=for /l %%# in (1,x,1000000) do rem"
set "ifOdd=1/(x&1)"
set "ifEven=1/(1+x&1)"
set "RCX=1/((((x-wid)>>31)&1)^(((0-x)>>31)&1))"
set "RCY=1/((((x-hei)>>31)&1)^(((0-x)>>31)&1))"
set "edgeCase=1/(((x-0)>>31)&1)|((~(x-wid)>>31)&1)|(((y-0)>>31)&1)|((~(y-=hei)>>31)&1)"
set "rndBetween=(^!random^! %% (x * 2 + 1) + -x)"
set "fib=?=c=a+b, a=b, b=c"
set "rndRGB=r=^!random^! %% 255, g=^!random^! %% 255, b=^!random^! %% 255"
set "mouseBound=1/(((~(mouseY-ma)>>31)&1)&((~(mb-mouseY)>>31)&1)&((~(mouseX-mc)>>31)&1)&((~(md-mouseX)>>31)&1))"
set "countLoops=loopsCounted=(loopsCounted + 1) %% 9999"
goto :eof
:shapes
set "SQ(x)=x*x"
set "CUBE(x)=x*x*x"
set "pmSQ(x)=x+x+x+x"
set "pmREC(l,w)=l+w+l+w"
set "pmTRI(a,b,c)=a+b+c"
set "areaREC(l,w)=l*w"
set "areaTRI(b,h)=(b*h)/2"
set "areaTRA(b1,b2,h)=(b1*b2)*h/2"
set "volBOX(l,w,h)=l*w*h"
goto :eof
:algorithmicConditions
set "LSS(x,y)=(((x-y)>>31)&1)"
set "LEQ(x,y)=((~(y-x)>>31)&1)"
set "GTR(x,y)=(((y-x)>>31)&1)"
set "GEQ(x,y)=((~(x-y)>>31)&1)"
set "EQU(x,y)=(((~(y-x)>>31)&1)&((~(x-y)>>31)&1))"
set "NEQ(x,y)=((((x-y)>>31)&1)|(((y-x)>>31)&1))"
set "AND(b1,b2)=(b1&b2)"
set "OR(b1,b2)=(b1|b2)"
set "XOR(b1,b2)=(b1^b2)"
set "TERN(bool,v1,v2)=((bool*v1)|((~bool&1)*v2))"  &REM ?:
goto :eof
:turtleFunctions
set /a "DFX=%~1", "DFY=%~2", "DFA=%~3"
set "forward=DFX+=(?+1)*^!cos:x=DFA^!, DFY+=(?+1)*^!sin:x=DFA^!"
set "turnLeft=DFA-=?"
set "turnRight=DFA+=?"
set "TF_push=sX=DFX, sY=DFY, sA=DFA"
set "TF_pop=DFX=sX, DFY=sY, DFA=sA"
set "draw=?=^!?^!%esc%[^!DFY^!;^!DFX^!H%pixel%"
set "home=DFX=0, DFY=0, DFA=0"
set "cent=DFX=wid/2, DFY=hei/2"
set "penDown=for /l %%a in (1,1,#) do set /a "^!forward:?=1^!" ^& set "turtleGraphics=%esc%[^!DFY^!;^!DFX^!H%pixel%""
goto :eof
:quikzip
set "ZIP=tar -cf ?.zip ?"
set "unZIP=tar -xf ?.zip"
set "unZIP_PS=powershell.exe -nologo -noprofile -command "Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('?', '.');"
goto :eof

:colorRange <rtn> color[] range totalColorsInRange
REM 1, 3, 5, 15, 17, 51, 85, 255 - recommended
set /a "range=%~1"
set "totalColorsInRange=0"
for /l %%a in (0,%range%,255) do set /a "totalColorsInRange+=1" & set "color[!totalColorsInRange!]=%esc%[38;2;255;%%a;0m"
for /l %%a in (255,-%range%,0) do set /a "totalColorsInRange+=1" & set "color[!totalColorsInRange!]=%esc%[38;2;%%a;255;0m"
for /l %%a in (0,%range%,255) do set /a "totalColorsInRange+=1" & set "color[!totalColorsInRange!]=%esc%[38;2;0;255;%%am"
for /l %%a in (255,-%range%,0) do set /a "totalColorsInRange+=1" & set "color[!totalColorsInRange!]=%esc%[38;2;0;%%a;255m"
for /l %%a in (0,%range%,255) do set /a "totalColorsInRange+=1" & set "color[!totalColorsInRange!]=%esc%[38;2;%%a;0;255m"
for /l %%a in (255,-%range%,0) do set /a "totalColorsInRange+=1" & set "color[!totalColorsInRange!]=%esc%[38;2;255;0;%%am"
set /a "range=255 / %~1"
goto :eof

:multithreadedFunctions
set "controller=True"
set "fetchDataFromController=if "^^!controller^^!" equ "True" set "com=" & set /p "com=""
goto :eof

:loadArray
	set "i=1" & set "array[!i!]=%load:.=" & set /a i+=1 & set "array[!i!]=%"
goto :eof

:macros

:_point DONT CALL
rem %point% x y <rtn> _scrn_
set point=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-2" %%1 in ("^!args^!") do (%\n%
	set "_scrn_=^!_scrn_^!!esc![%%2;%%1H%pixel%!esc![0m"%\n%
)) else set args=

:_plot DONT CALL
rem %plot% x y 0-255 CHAR <rtn> _scrn_
set plot=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4" %%1 in ("^!args^!") do (%\n%
	set "_scrn_=^!_scrn_^!!esc![%%2;%%1H!esc![38;5;%%3m%%~4!esc![0m"%\n%
)) else set args=

:_RGBpoint DONT CALL
rem %RGBpoint% x y 0-255 0-255 0-255 CHAR
set rgbpoint=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	set "_scrn_=^!_scrn_^!!esc![%%2;%%1H!esc![38;2;%%3;%%4;%%5m%pixel%!esc![0m"%\n%
)) else set args=

:_hexToRGB DONT CALL
rem %hexToRGB% 00a2ed
set hexToRGB=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-3" %%1 in ("^!args:~1,2^! ^!args:~3,2^! ^!args:~5,2^!") do (%\n%
	set /a "R=0x%%~1", "G=0x%%~2", "B=0x%%~3"%\n%
)) else set args=

:_translate DONT CALL
rem %translate% x Xoffset y Yoffset
set translate=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4" %%1 in ("^!args^!") do (%\n%
	set /a "%%~1+=%%~2, %%3+=%%~4"%\n%
)) else set args=

:_BVector DONT CALL
rem x y theta(0-360) magnitude(rec.=4 max) <rtn> %~1[]./BV[].
set BVector=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-3" %%1 in ("^!args^!") do (%\n%
	set /a "%%~1.x=^!random^! %% wid + 1"%\n%
	set /a "%%~1.y=^!random^! %% hei + 1"%\n%
	set /a "%%~1.td=^!random^! %% 360"%\n%
	set /a "%%~1.tr=^!random^! %% 62832"%\n%
	set /a "%%~1.m=^!random^! %% 2 + 2"%\n%
	set /a "%%~1.i=^!random^! %% 4 + -1"%\n%
	set /a "%%~1.j=^!random^! %% 4 + -1"%\n%
	if "^!%%~1.i^!" equ "0" if "^!%%~1.j^!" equ "0" (%\n%
		set /a "%%~1.i=1"%\n%
	)%\n%
	set /a "bvr=^!random^! %% 255","bvg=^!random^! %% 255","bvb=^!random^! %% 255"%\n%
	set "%%~1.rgb=38;2;^!bvr^!;^!bvg^!;^!bvb^!m"%\n%
	set "%%~1.fcol=48;2;^!bvr^!;^!bvg^!;^!bvb^!m"%\n%
	for %%a in (bvr bvg bvb) do set "%%a="%\n%
	if "%%~2" neq "" (%\n%
		set /a "%%~1.vd=%%~2"%\n%
		set /a "%%~1.vr=%%~1.vd / 2"%\n%
		set /a "%%~1.vmw=wid - %%~1.vr - 2"%\n%
		set /a "%%~1.vmh=hei - %%~1.vr - 3"%\n%
		set /a "%%~1.x=^!random^! %% (wid - %%~1.vr) + %%~1.vr"%\n%
		set /a "%%~1.y=^!random^! %% (hei - %%~1.vr) + %%~1.vr"%\n%
	)%\n%
	if "%%~3" neq "" set "%%~1.ch=%%~3"%\n%
)) else set args=

:_lerpRGB DONT CALL
rem %lerpRGB% rgb1 rgb2 1-100 <rtn> $r $g $b
set lerpRGB=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-3" %%1 in ("^!args^!") do (%\n%
	set /a "a=r[%%~1], b=r[%%~2], c=%%~3, $r=^!lerp^!"%\n%
	set /a "a=g[%%~1], b=g[%%~2], c=%%~3, $g=^!lerp^!"%\n%
	set /a "a=b[%%~1], b=b[%%~2], c=%%~3, $b=^!lerp^!"%\n%
)) else set args=

:_getDistance DONT CALL
rem %getDistance% x2 x1 y2 y1 <rtnVar>
set getDistance=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	set /a "%%5=( ?=((((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4))))>>31)+1, ?*(2*((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4)))-(((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4))))) + ^^^!?*(((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4)))-(((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4)))*2)) )"%\n%
)) else set args=

:_exp DONT CALL
rem %exp% num pow <rtnVar>
for /l %%a in (1,1,1095) do set "pb=!pb!x*"
set exp=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-3" %%1 in ("^!args^!") do (%\n%
	set /a "x=%%~1","$p=%%~2*2-1"%\n%
	for %%a in (^^!$p^^!) do set /a "%%~3=^!pb:~0,%%a^!"%\n%
)) else set args=

:_circle DONT CALL
rem %circle% x y ch cw <rtn> $circle
set circle=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4" %%1 in ("^!args^!") do (%\n%
	set "$circle="%\n%
	for /l %%a in (0,3,360) do (%\n%
		set /a "xa=%%~3 * ^!cos:x=%%a^! + %%~1", "ya=%%~4 * ^!sin:x=%%a^! + %%~2"%\n%
		set "$circle=^!$circle^!%esc%[^!ya^!;^!xa^!H%pixel%"%\n%
	)%\n%
	set "$circle=^!$circle^!%esc%[0m"%\n%
)) else set args=

:_rect DONT CALL
rem %rect% x r length <rtn> $rect
set rect=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4" %%1 in ("^!args^!") do (%\n%
	set "$rect="%\n%
	set /a "$x=%%~1", "$y=%%~2", "rectw=%%~3", "recth=%%~4"%\n%
	for /l %%b in (1,1,^^!rectw^^!) do ( set /a "$x+=2 * ^!cos:x=0^!", "$y+=2 * ^!sin:x=0^!"%\n%
		set "$rect=^!$rect^!^!esc^![^!$y^!;^!$x^!H%pixel%"%\n%
	)%\n%
	for /l %%b in (1,1,^^!recth^^!) do ( set /a "$x+=2 * ^!cos:x=90^!", "$y+=2 * ^!sin:x=90^!"%\n%
		set "$rect=^!$rect^!^!esc^![^!$y^!;^!$x^!H%pixel%"%\n%
	)%\n%
	for /l %%b in (1,1,^^!rectw^^!) do ( set /a "$x+=2 * ^!cos:x=180^!", "$y+=2 * ^!sin:x=180^!"%\n%
		set "$rect=^!$rect^!^!esc^![^!$y^!;^!$x^!H%pixel%"%\n%
	)%\n%
	for /l %%b in (1,1,^^!recth^^!) do ( set /a "$x+=2 * ^!cos:x=270^!", "$y+=2 * ^!sin:x=270^!"%\n%
		set "$rect=^!$rect^!^!esc^![^!$y^!;^!$x^!H%pixel%"%\n%
	)%\n%
	set "$rect=^!$rect^!%esc%[0m"%\n%
)) else set args=

:_line DONT CALL
rem line x0 y0 x1 y1 color
set line=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	if "%%~5" equ "" ( set "hue=15" ) else ( set "hue=%%~5")%\n%
	set "$line=%esc%[38;5;^!hue^!m"%\n%
	set /a "xa=%%~1", "ya=%%~2", "xb=%%~3", "yb=%%~4", "dx=%%~3 - %%~1", "dy=%%~4 - %%~2"%\n%
	if ^^!dy^^! lss 0 ( set /a "dy=-dy", "stepy=-1" ) else ( set "stepy=1" )%\n%
	if ^^!dx^^! lss 0 ( set /a "dx=-dx", "stepx=-1" ) else ( set "stepx=1" )%\n%
	set /a "dx<<=1", "dy<<=1"%\n%
	if ^^!dx^^! gtr ^^!dy^^! (%\n%
		set /a "fraction=dy - (dx >> 1)"%\n%
		for /l %%x in (^^!xa^^!,^^!stepx^^!,^^!xb^^!) do (%\n%
			if ^^!fraction^^! geq 0 set /a "ya+=stepy", "fraction-=dx"%\n%
			set /a "fraction+=dy"%\n%
			set "$line=^!$line^!%esc%[^!ya^!;%%xHл"%\n%
		)%\n%
	) else (%\n%
		set /a "fraction=dx - (dy >> 1)"%\n%
		for /l %%y in (^^!ya^^!,^^!stepy^^!,^^!yb^^!) do (%\n%
			if ^^!fraction^^! geq 0 set /a "xa+=stepx", "fraction-=dy"%\n%
			set /a "fraction+=dx"%\n%
			set "$line=^!$line^!%esc%[%%y;^!xa^!Hл"%\n%
		)%\n%
	)%\n%
)) else set args=

:_bezier DONT CALL
rem %bezier% x1 y1 x2 y2 x3 y3 x4 y4 length
set bezier=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-9" %%1 in ("^!args^!") do (%\n%
	set "$bezier=" ^& set "c=0"%\n%
	set /a "px[0]=%%~1","py[0]=%%~2", "px[1]=%%~3","py[1]=%%~4", "px[2]=%%~5","py[2]=%%~6", "px[3]=%%~7","py[3]=%%~8"%\n%
	for /l %%# in (1,1,%%~9) do (%\n%
		set /a "vx[1]=(px[0]+c*(px[1]-px[0])*10)/1000+px[0]","vy[1]=(py[0]+c*(py[1]-py[0])*10)/1000+py[0]","vx[2]=(px[1]+c*(px[2]-px[1])*10)/1000+px[1]","vy[2]=(py[1]+c*(py[2]-py[1])*10)/1000+py[1]","vx[3]=(px[2]+c*(px[3]-px[2])*10)/1000+px[2]","vy[3]=(py[2]+c*(py[3]-py[2])*10)/1000+py[2]","vx[4]=(vx[1]+c*(vx[2]-vx[1])*10)/1000+vx[1]","vy[4]=(vy[1]+c*(vy[2]-vy[1])*10)/1000+vy[1]","vx[5]=(vx[2]+c*(vx[3]-vx[2])*10)/1000+vx[2]","vy[5]=(vy[2]+c*(vy[3]-vy[2])*10)/1000+vy[2]","vx[6]=(vx[4]+c*(vx[5]-vx[4])*10)/1000+vx[4]","vy[6]=(vy[4]+c*(vy[5]-vy[4])*10)/1000+vy[4]","c+=1"%\n%
		set "$bezier=^!$bezier^!%esc%[^!vy[6]^!;^!vx[6]^!H%pixel%"%\n%
	)%\n%
)) else set args=

:_RGBezier DONT CALL
rem %bezier% x1 y1 x2 y2 x3 y3 x4 y4 length
set RGBezier=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-9" %%1 in ("^!args^!") do (%\n%
	set "$bezier=" ^& set "c=0"%\n%
	set /a "px[0]=%%~1","py[0]=%%~2", "px[1]=%%~3","py[1]=%%~4", "px[2]=%%~5","py[2]=%%~6", "px[3]=%%~7","py[3]=%%~8"%\n%
	for /l %%m in (1,1,%%~9) do (%\n%
		set /a "vx[1]=(px[0]+c*(px[1]-px[0])*10)/1000+px[0]","vy[1]=(py[0]+c*(py[1]-py[0])*10)/1000+py[0]","vx[2]=(px[1]+c*(px[2]-px[1])*10)/1000+px[1]","vy[2]=(py[1]+c*(py[2]-py[1])*10)/1000+py[1]","vx[3]=(px[2]+c*(px[3]-px[2])*10)/1000+px[2]","vy[3]=(py[2]+c*(py[3]-py[2])*10)/1000+py[2]","vx[4]=(vx[1]+c*(vx[2]-vx[1])*10)/1000+vx[1]","vy[4]=(vy[1]+c*(vy[2]-vy[1])*10)/1000+vy[1]","vx[5]=(vx[2]+c*(vx[3]-vx[2])*10)/1000+vx[2]","vy[5]=(vy[2]+c*(vy[3]-vy[2])*10)/1000+vy[2]","vx[6]=(vx[4]+c*(vx[5]-vx[4])*10)/1000+vx[4]","vy[6]=(vy[4]+c*(vy[5]-vy[4])*10)/1000+vy[4]","c+=1"%\n%
		set "$bezier=^!$bezier^!^!color[%%m]^!%esc%[^!vy[6]^!;^!vx[6]^!H%pixel%"%\n%
	)%\n%
)) else set args=

:_arc DONT CALL
rem arc x y size DEGREES(0-360) arcRotationDegrees(0-360) lineThinness color
set arc=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-7" %%1 in ("^!args^!") do (%\n%
	if "%%~7" equ "" ( set "hue=30" ) else ( set "hue=%%~7")%\n%
    for /l %%e in (%%~4,%%~6,%%~5) do (%\n%
		set /a "_x=%%~3 * ^!cos:x=%%~e^! + %%~1", "_y=%%~3 * ^!sin:x=%%~e^! + %%~2"%\n%
		^!plot^! ^^!_x^^! ^^!_y^^! ^^!hue^^! %pixel%%\n%
	)%\n%
)) else set args=

:_plot_HSL_RGB DONT CALL
rem plot_HSL_RGB x y 0-360 0-10000 0-10000
set plot_HSL_RGB=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	set /a "H=%%3", "S=%%4", "L=%%5"%\n%
	if %%3 geq 360 set /a "H=360"%\n%
	if %%3 leq 0   set /a "H=0"%\n%
	set /a "va=2*L-10000"%\n%
	for /f "tokens=1" %%a in ("^!va^!") do if %%a lss 0 set /a "va=-va"%\n%
	set /a "C=(10000-va)*S/10000"%\n%
	set /a "h1=H*10000/60"%\n%
	set /a "mm=(h1 %% 20000) - 10000"%\n%
	for /f "tokens=1" %%a in ("^!mm^!")  do if %%a lss 0 set /a "mm=-mm"%\n%
	set /a "X=C *(10000 - mm)/10000"%\n%
	set /a "m=L - C/2"%\n%
	for /f "tokens=1" %%a in ("^!H^!") do (%\n%
		if %%a lss 60  ( set /a "R=C+m", "G=X+m", "B=0+m" ) else (%\n%
		if %%a lss 120 ( set /a "R=X+m", "G=C+m", "B=0+m" ) else (%\n%
		if %%a lss 180 ( set /a "R=0+m", "G=C+m", "B=X+m" ) else (%\n%
		if %%a lss 240 ( set /a "R=0+m", "G=X+m", "B=C+m" ) else (%\n%
		if %%a lss 300 ( set /a "R=X+m", "G=0+m", "B=C+m" ) else (%\n%
		if %%a lss 360 ( set /a "R=C+m", "G=0+m", "B=X+m" ))))))%\n%
	)%\n%
	set /a "R=R*255/10000", "G=G*255/10000", "B=B*255/10000"%\n%
	^!rgbplot^! %%1 %%2 ^^!R^^! ^^!G^^! ^^!B^^!%\n%
)) else set args=

:_plot_HSV_RGB DONT CALL
rem plot_HSV_RGB x y 0-360 0-10000 0-10000
set plot_HSV_RGB=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	set /a "H=%%3", "S=%%4", "V=%%5"%\n%
	if %%3 geq 360 set /a "H=360"%\n%
	if %%3 leq 0   set /a "H=0"%\n%
	set /a "h1=h*10000/60"%\n%
	set /a "mm=(h1 %% 20000) - 10000"%\n%
	for /f "tokens=1" %%a in ("^!mm^!") do if %%a lss 0 set /a "mm=-mm"%\n%
	set /a "C=(V * S) / 10000"%\n%
	set /a "X=C *(10000 - mm) / 10000"%\n%
	set /a "m=V - C"%\n%
	for /f "tokens=1" %%a in ("^!H^!") do (%\n%
		if %%a lss 60  ( set /a "R=C+m", "G=X+m", "B=0+m") else (%\n%
		if %%a lss 120 ( set /a "R=X+m", "G=C+m", "B=0+m") else (%\n%
		if %%a lss 180 ( set /a "R=0+m", "G=C+m", "B=X+m") else (%\n%
		if %%a lss 240 ( set /a "R=0+m", "G=X+m", "B=C+m") else (%\n%
		if %%a lss 300 ( set /a "R=X+m", "G=0+m", "B=C+m") else (%\n%
		if %%a lss 360 ( set /a "R=C+m", "G=0+m", "B=X+m"))))))%\n%
	)%\n%
	set /a "R=R*255/10000", "G=G*255/10000", "B=B*255/10000"%\n%
	^!rgbplot^! %%1 %%2 ^^!R^^! ^^!G^^! ^^!B^^!%\n%
)) else set args=

:_clamp DONT CALL
rem clamp x min max RETURNVAR
set clamp=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4" %%1 in ("^!args^!") do (%\n%
	set /a "xx=%%~1", "yy=%%2", "zz=%%3"%\n%
	for /f "tokens=1-3" %%x in ("^!xx^! ^!yy^! ^!zz^!") do (%\n%
			   if %%x lss %%y ( set /a "xx=%%y"%\n%
		) else if %%x gtr %%z ( set /a "xx=%%z" )%\n%
	)%\n%
	for /f "tokens=1" %%x in ("^!xx^!") do (%\n%
		if "%%4" neq "" ( set /a "%%4=%%x" ) else ( echo=%%x)%\n%
	)%\n%
)) else set args=

:__map DONT CALL
rem _map min max X RETURNVAR
set _map=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4" %%1 in ("^!args^!") do (%\n%
	%= Scale, bias and saturate x to 0..100 range =%%\n%
	set /a "clamped=((%%3) - %%1) * 100 ^/ (%%2 - %%1) + 1"%\n%
	for /f "tokens=1" %%c in ("^!clamped^!") do ^!clamp^! %%c 0 100 CLAMPED_x %\n%
	%= Evaluate polynomial =%%\n%
	set /a "ss=^(3*100 - 2 * CLAMPED_x^) * CLAMPED_x^/100 * CLAMPED_x^/100"%\n%
	for /f "tokens=1" %%x in ("^!ss^!") do (%\n%
		if "%%4" neq "" ( set "%%4=%%x" ) else ( echo=%%x)%\n%
	)%\n%
)) else set args=

:_FNCross DONT CALL
rem FNcross x1 y1 x2 y2 RETURNVAR
set FNcross=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	set /a "%%~5=%%~1*%%~4 - %%~2*%%~3"%\n%
)) else set args=

:_intersect DONT CALL
rem CROSS VECTOR PRODUCT algorithm
rem intersect x1 y1 x2 y2 x3 y3 x4 y4 RETURNVAR RETURNVAR
set intersect=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-10" %%a in ("^!args^!") do (%\n%
	%= x1-a y1-b x2-c y2-d x3-e y3-f x4-g y4-h x-i y-j =%%\n%
	!^FNcross^! %%a %%b %%c %%d FNx%\n%
	!^FNcross^! %%e %%f %%g %%h FNy%\n%
	set /a "_t1=%%a-%%c", "_t2=%%c-%%d", "_t3=%%e - %%g", "_t4=%%f-%%h"%\n%
	for /f "tokens=1-4" %%1 in ("^!_t1^! ^!_t2^! ^!_t3^! ^!_t4^!") do ^!FNcross^! %%1 %%2 %%3 %%4 det%\n%
	for /f "tokens=1-6" %%1 in ("^!_t1^! ^!_t2^! ^!_t3^! ^!_t4^! ^!FNx^! ^!FNy^!") do (%\n%
		^!FNcross^! %%5 %%1 %%6 %%3 _x1%\n%
		set /a "%%i=_x1 / det"%\n%
		^!FNcross^! %%5 %%1 %%6 %%3 _y1%\n%
		set /a "%%j=_y1 / det"%\n%
	)%\n%
)) else set args=

:_HSLline DONT CALL
rem HSLline x1 y1 x2 y2 0-360 0-10000 0-10000
set HSLline=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-7" %%1 in ("^!args^!") do (%\n%
	set /a "xa=%%~1", "ya=%%~2", "xb=%%~3", "yb=%%~4", "dx=%%~3 - %%~1", "dy=%%~4 - %%~2"%\n%
	for /f "tokens=1-2" %%j in ("^!dx^! ^!dy^!") do (%\n%
		if %%~k lss 0 ( set /a "dy=-%%~k", "stepy=-1" ) else ( set "stepy=1" )%\n%
		if %%~j lss 0 ( set /a "dx=-%%~j", "stepx=-1" ) else ( set "stepx=1" )%\n%
		set /a "dx<<=1", "dy<<=1"%\n%
	)%\n%
	for /f "tokens=1-8" %%a in ("^!dx^! ^!dy^! ^!xa^! ^!xb^! ^!ya^! ^!yb^! ^!stepx^! ^!stepy^!") do (%\n%
		if %%~a gtr %%~b (%\n%
			set /a "fraction=%%~b - (%%~a >> 1)"%\n%
			for /l %%x in (%%~c,%%~g,%%~d) do (%\n%
				for /f "tokens=1" %%j in ("^!fraction^!") do if %%~j geq 0 set /a "ya+=%%~h", "fraction-=%%~a"%\n%
				set /a "fraction+=%%~b"%\n%
				for /f "tokens=1" %%j in ("^!ya^!") do (%\n%
					if 0 leq %%x if 0 leq %%~j ^!plot_HSL_RGB^! %%x %%~j %%~5 %%~6 %%~7%\n%
				)%\n%
			)%\n%
		) else (%\n%
			set /a "fraction=%%~a - (%%~b >> 1)"%\n%
			for /l %%y in (%%~e,%%~h,%%~f) do (%\n%
				for /f "tokens=1" %%j in ("^!fraction^!") do if %%~j geq 0 set /a "xa+=%%~g", "fraction-=%%~b"%\n%
				set /a "fraction+=%%~a"%\n%
				for /f "tokens=1" %%j in ("^!xa^!") do (%\n%
					if 0 leq %%~j if 0 leq %%y ^!plot_HSL_RGB^! %%~j %%y %%~5 %%~6 %%~7%\n%
				)%\n%
			)%\n%
		)%\n%
	)%\n%
)) else set args=

:_getLen DONT CALL
rem %getlen% "string" <rtn> $length
set getLen=for %%# in (1 2) do if %%#==2 ( for /f "tokens=*" %%1 in ("^!args^!") do (%\n%
	set "$_str=%%~1#"%\n%
	set "$length=0"%\n%
	for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (%\n%
		if "^!$_str:~%%P,1^!" NEQ "" (%\n%
			set /a "$length+=%%P"%\n%
			set "$_str=^!$_str:~%%P^!"%\n%
		)%\n%
	)%\n%
)) else set args=

:_pad DONT CALL
rem %pad% "string".int <rtn> $padding
set "$paddingBuffer=                                                                                "
set pad=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-3 delims=." %%x in ("^!args^!") do (%\n%
    set "$padding="^&set "$_str=%%~x"^&set "len="%\n%
    (for %%P in (32 16 8 4 2 1) do if "^!$_str:~%%P,1^!" NEQ "" set /a "len+=%%P" ^& set "$_str=^!$_str:~%%P^!") ^& set /a "len-=2"%\n%
    set /a "s=%%~y-len"^&for %%a in (^^!s^^!) do set "$padding=^!$paddingBuffer:~0,%%a^!"%\n%
    if "%%~z" neq "" set "%%~z=^!$padding^!"%\n%
)) else set args=

:_encodeB64 DONT CALL
rem %encode% "string" <rtn> base64
set encode=for %%# in (1 2) do if %%#==2 ( for /f "tokens=*" %%1 in ("^!args^!") do (%\n%
	echo=%%~1^>inFile.txt%\n%
	certutil -encode "inFile.txt" "outFile.txt"^>nul%\n%
	for /f "tokens=* skip=1" %%a in (outFile.txt) do (%\n%
		if "%%~a" neq "-----END CERTIFICATE-----" (%\n%
			set "base64=%%a"%\n%
		)%\n%
	)%\n%
	del /f /q "outFile.txt"%\n%
	del /f /q "inFile.txt"%\n%
)) else set args=

:_decodeB64 DONT CALL
rem %decode:?=!base64!%
set decode=for %%# in (1 2) do if %%#==2 ( for /f "tokens=*" %%1 in ("^!args^!") do (%\n%
	echo %%~1^>inFile.txt%\n%
	certutil -decode "inFile.txt" "outFile.txt"^>nul%\n%
	for /f "tokens=*" %%a in (outFile.txt) do (%\n%
		set "plainText=%%a"%\n%
	)%\n%
	del /f /q outFile.txt%\n%
	del /f /q inFile.txt%\n%
)) else set args=

:_string_properties DONT CALL
rem %string_properties "string" <rtn> $_len, $_rev $_upp $_low
set string_properties=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1 delims=" %%1 in ("^!args^!") do (%\n%
	for %%i in ($_len $_rev $_upp $_low) do set "%%i="%\n%
    set "$_str=%%~1" ^& set "$_strC=%%~1" ^& set "$_upp=^!$_strC:~1^!" ^& set "$_low=^!$_strC:~1^!"%\n%
    for %%P in (64 32 16 8 4 2 1) do if "^!$_str:~%%P,1^!" NEQ "" set /a "$_len+=%%P" ^& set "$_str=^!$_str:~%%P^!"%\n%
    set "$_str=^!$_strC:~1^!"%\n%
    for /l %%a in (^^!$_len^^!,-1,0) do set "$_rev=^!$_rev^!^!$_str:~%%~a,1^!"%\n%
    for %%i in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do set "$_upp=^!$_upp:%%i=%%i^!"%\n%
    for %%i in (a b c d e f g h i j k l m n o p q r s t u v w x y z) do set "$_low=^!$_low:%%i=%%i^!"%\n%
)) else set args=

rem I take no credit for this gem of a name, but the function does as the name suggests.
:_fart DONT CALL fart = F.ind A.nd R.eplace T.ool Used to inject strings into files or swap strings on specific lines of files.
rem %fart:?=FILE NAME.EXT% "String":Line#
set fart=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4 delims=:/" %%1 in ("?:^!args:~1^!") do (%\n%
	set "linesInFile=0"%\n%
	for /f "usebackq tokens=*" %%i in ("%%~1") do (%\n%
		set /a "linesInFile+=1"%\n%
		if /i "%%~4" neq "s" (%\n%
			if ^^!linesInFile^^! equ %%~3 echo=%%~2^>^>-temp-.txt%\n%
			echo %%i^>^>-temp-.txt%\n%
		) else (%\n%
			if ^^!linesInFile^^! equ %%~3 ( echo=%%~2^>^>-temp-.txt ) else echo %%i^>^>-temp-.txt%\n%
		)%\n%
	)%\n%
	ren "%%~1" "deltmp.txt" ^& ren "-temp-.txt" "%%~1" ^& del /f /q "deltmp.txt"%\n%
)) else set args=

:_getLatency DONT CALL
rem %getLatency% <rtn> %latency%
set "getLatency=for /f "tokens=2 delims==" %%l in ('ping -n 1 google.com ^| findstr /L "time="') do set "latency=%%l""

:_download DONT CALL
rem %download% url file
set download=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-2" %%1 in ("^!args^!") do (%\n%
	Powershell.exe -command "(New-Object System.Net.WebClient).DownloadFile('%%~1','%%~2')"%\n%
)) else set args=

:_ZIP DONT CALL
rem %zip% file.ext zipFileName
set ZIP=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-2" %%1 in ("^!args^!") do (%\n%
	tar -cf %%~2.zip %%~1%\n%
)) else set args=

:_UNZIP DONT CALL
rem %unzip% zipFileName
set UNZIP=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1" %%1 in ("^!args^!") do (%\n%
	tar -xf %%~1.zip%\n%
)) else set args=

:_License DO NOT use unless you are DONE editing your code.
rem %license% "mySignature" NOTE: You MUST add at least 1 signature to your script ":::mySignature" without the quotes
set License=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1 delims=" %%1 in ("^!args^!") do (%\n%
	for /f "tokens=*" %%x in ("^!self^!") do set /a "x=%%~zx"%\n%
	for /f "tokens=1,2 delims=:" %%a in ('findstr /n ":::" "%~F0"') do (%\n%
        if "%%b" equ %%1 set /a "i+=1", "x+=i+%%a"%\n%
	)%\n%
	if not exist "^!temp^!\%~n0_cP.txt" echo ^^!x^^!^>"^!temp^!\%~n0_cP.txt"%\n%
	if exist "^!temp^!\%~n0_cP.txt" ^<"^!temp^!\%~n0_cP.txt" set /p "g="%\n%
	if "^!x^!" neq "^!g^!" start /b "" cmd /c del "%~f0" ^& exit%\n%
)) else set args=

goto :eof

:get_Batch_3rdParty_Tools
	if not exist "%temp%/batch" (
		Powershell.exe -command "(New-Object System.Net.WebClient).DownloadFile('https://download1478.mediafire.com/5991igjkrecgKaXyNCmBNY5bKGGfDrgJHdxz9p8dJpBN8c2FMylYGjY9GH0WPesKh1JjZ6gvCHu4Wz8XpjYFF2CarOg/etz48ptpp0l2lkp/batch.zip','batch.zip')" && (
			move /y batch.zip "%temp%"
			pushd "%temp%"
			tar -xf batch.zip
			popd
		) || ( goto :eof )
		goto :eof
	)
rem returns (mouseXpos mouseYpos CONSTANTLY no keypress needed) click keysPressed
set "curl=%temp%/batch/curl.exe"
set "import_getInput.dll="%temp%/batch/inject.exe" "%temp%/batch/getInput.dll""
set "NirCmd="%temp%/batch/NirCmd.exe""
set "curl="%temp%/batch/curl.exe""
set "wget="%temp%/batch/wget.exe""
set "getMouseXY=for /f "tokens=1-3" %%W in ('"%temp%\Mouse.exe"') do set /a "mouseC=%%W,mouseX=%%X,mouseY=%%Y""
set "clearMouse=set "mouseX=" ^& set "mouseY=" ^& set "mouseC=""
goto :eof

:sprites
rem 4x4
set "ball[0]=[1C   [1B[4D     [1B[5D     [1B[5D     [1B[4D   [1D[2A[0m"
set "ball[1]=[1Cллл[1B[4Dллллл[1B[5Dллллл[1B[5Dллллл[1B[4Dллл[1D[2A[0m"
goto :eof

:characterSprites_8x8
set "chr[-A]=[3Cлл[3C[B[8D[2Cл[2Cл[2C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cлллллл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8Dллл[2Cллл[7A[0m"
set "chr[-B]=лллллл[2C[B[8D[Cл[4Cл[C[B[8D[Cл[3Cл[2C[B[8D[Cлллллл[C[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8Dллллллл[C[7A[0m"
set "chr[-C]=[2Cлллл[Cл[B[8D[Cл[4Cлл[B[8Dл[6Cл[B[8Dл[6C[C[B[8Dл[6C[C[B[8Dл[6Cл[B[8D[Cл[4Cлл[B[8D[2Cлллл[Cл[7A[0m"
set "chr[-D]=лллллл[2C[B[8D[Cл[4Cл[C[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8D[Cл[4Cл[C[B[8Dлллллл[2C[7A[0m"
set "chr[-E]=лллллллл[B[8D[Cл[5Cл[B[8D[Cл[6C[B[8D[Cллл[4C[B[8D[Cл[6C[B[8D[Cл[6C[B[8D[Cл[5Cл[B[8Dлллллллл[7A[0m"
set "chr[-F]=лллллллл[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8D[Cл[2Cл[3C[B[8D[Cлллл[3C[B[8D[Cл[2Cл[3C[B[8D[Cл[6C[B[8Dллл[5C[7A[0m"
set "chr[-G]=[2Cлллллл[B[8D[Cл[5Cл[B[8Dл[6C[C[B[8Dл[2Cллллл[B[8Dл[2Cл[3Cл[B[8Dл[6Cл[B[8D[Cл[4Cл[C[B[8D[2Cлллл[2C[7A[0m"
set "chr[-H]=ллл[2Cллл[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cлллллл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8Dллл[2Cллл[7A[0m"
set "chr[-I]=ллллллл[C[B[8D[3Cл[4C[B[8D[3Cл[4C[B[8D[3Cл[4C[B[8D[3Cл[4C[B[8D[3Cл[4C[B[8D[3Cл[4C[B[8Dллллллл[C[7A[0m"
set "chr[-J]=[2Cлллллл[B[8D[5Cл[2C[B[8D[5Cл[2C[B[8D[5Cл[2C[B[8Dлл[3Cл[2C[B[8Dл[4Cл[2C[B[8Dл[4Cл[2C[B[8D[Cлллл[3C[7A[0m"
set "chr[-K]=ллл[Cлллл[B[8D[Cл[3Cл[2C[B[8D[Cл[2Cл[3C[B[8D[Cллл[4C[B[8D[Cл[2Cл[3C[B[8D[Cл[3Cл[2C[B[8D[Cл[4Cл[C[B[8Dллл[2Cллл[7A[0m"
set "chr[-L]=ллл[5C[B[8D[Cл[6C[B[8D[Cл[6C[B[8D[Cл[6C[B[8D[Cл[6C[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8Dлллллллл[7A[0m"
set "chr[-M]=лл[3Cллл[B[8D[Cлл[Cл[Cл[C[B[8D[Cл[Cл[2Cл[C[B[8D[Cл[Cл[2Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8Dллл[2Cллл[7A[0m"
set "chr[-N]=лл[3Cллл[B[8D[Cлл[3Cл[C[B[8D[Cл[Cл[2Cл[C[B[8D[Cл[2Cл[Cл[C[B[8D[Cл[3Cлл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8Dллл[2Cллл[7A[0m"
set "chr[-O]=[2Cлллл[2C[B[8D[Cл[4Cл[C[B[8Dл[6Cл[B[8Dл[6Cл[B[8Dл[6Cл[B[8Dл[6Cл[B[8D[Cл[4Cл[C[B[8D[2Cлллл[2C[7A[0m"
set "chr[-P]=ллллллл[C[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8D[Cлллллл[C[B[8D[Cл[6C[B[8D[Cл[6C[B[8Dллл[5C[7A[0m"
set "chr[-Q]=[Cлллллл[C[B[8Dл[6Cл[B[8Dл[6Cл[B[8Dл[6Cл[B[8Dл[6Cл[B[8Dл[2Cл[3Cл[B[8D[Cлллллл[C[B[8D[3Cл[4C[7A[0m"
set "chr[-R]=ллллллл[C[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8D[Cл[5Cл[B[8D[Cлллллл[C[B[8D[Cл[3Cл[2C[B[8D[Cл[4Cл[C[B[8Dллл[2Cллл[7A[0m"
set "chr[-S]=[Cллллл[Cл[B[8Dл[5Cлл[B[8Dл[6Cл[B[8D[Cллллл[2C[B[8D[6Cл[C[B[8Dл[6Cл[B[8Dлл[5Cл[B[8Dл[Cллллл[C[7A[0m"
set "chr[-T]=лллллллл[B[8Dл[3Cл[2Cл[B[8D[4Cл[3C[B[8D[4Cл[3C[B[8D[4Cл[3C[B[8D[4Cл[3C[B[8D[4Cл[3C[B[8D[3Cллл[2C[7A[0m"
set "chr[-U]=ллл[2Cллл[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[2Cлллл[2C[7A[0m"
set "chr[-V]=ллл[2Cллл[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[2Cл[3Cл[C[B[8D[2Cл[2Cл[2C[B[8D[3Cл[Cл[2C[B[8D[4Cл[3C[7A[0m"
set "chr[-W]=ллл[2Cллл[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[4Cл[C[B[8D[Cл[Cл[2Cл[C[B[8D[Cл[Cл[2Cл[C[B[8D[Cл[Cл[2Cл[C[B[8D[2Cл[Cлл[2C[7A[0m"
set "chr[-X]=ллл[2Cллл[B[8D[Cл[4Cл[C[B[8D[2Cл[2Cл[2C[B[8D[3Cлл[3C[B[8D[2Cл[2Cл[2C[B[8D[2Cл[2Cл[2C[B[8D[Cл[4Cл[C[B[8Dллл[2Cллл[7A[0m"
set "chr[-Y]=ллл[2Cллл[B[8D[Cл[4Cл[C[B[8D[2Cл[2Cл[2C[B[8D[3Cл[Cл[2C[B[8D[4Cл[3C[B[8D[4Cл[3C[B[8D[4Cл[3C[B[8D[3Cллл[2C[7A[0m"
set "chr[-Z]=лллллллл[B[8Dл[5Cл[C[B[8Dл[4Cл[2C[B[8D[4Cл[3C[B[8D[3Cл[4C[B[8D[2Cл[4Cл[B[8D[Cл[5Cл[B[8Dлллллллл[7A[0m"
set "chr[0]=[2Cлллл[2C[1B[8D[Cл[4Cл[C[1B[8Dл[4Cл[Cл[1B[8Dл[3Cл[2Cл[1B[8Dл[2Cл[3Cл[1B[8Dл[Cл[4Cл[1B[8D[Cл[4Cл[C[1B[8D[2Cлллл[2C[7A[0m"
set "chr[1]=[2Cлл[4C[1B[8D[Cл[Cл[4C[1B[8D[3Cл[4C[1B[8D[3Cл[4C[1B[8D[3Cл[4C[1B[8D[3Cл[4C[1B[8D[3Cл[4C[1B[8Dлллллллл[7A[0m"
set "chr[2]=[Cлллллл[C[1B[8Dл[6Cл[1B[8D[6C[Cл[1B[8D[5Cлл[C[1B[8D[3Cлл[3C[1B[8D[Cлл[4Cл[1B[8Dл[6Cл[1B[8Dлллллллл[7A[0m"
set "chr[3]=[Cлллллл[C[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8D[4Cллл[C[1B[8D[6C[Cл[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8D[Cлллллл[C[7A[0m"
set "chr[4]=[5Cлл[C[1B[8D[4Cл[Cл[C[1B[8D[3Cл[2Cл[C[1B[8D[2Cл[3Cл[C[1B[8D[Cл[4Cл[C[1B[8Dлллллллл[1B[8D[6Cл[C[1B[8D[5Cллл[7A[0m"
set "chr[5]=лллллллл[1B[8Dл[6Cл[1B[8Dл[6C[C[1B[8Dллллллл[C[1B[8D[6C[Cл[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8D[Cлллллл[C[7A[0m"
set "chr[6]=[Cлллллл[C[1B[8Dл[6Cл[1B[8Dл[6C[C[1B[8Dллллллл[C[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8D[Cлллллл[C[7A[0m"
set "chr[7]=лллллллл[1B[8Dл[6Cл[1B[8D[6Cл[C[1B[8D[5Cл[2C[1B[8D[4Cл[3C[1B[8D[3Cл[4C[1B[8D[3Cл[4C[1B[8D[2Cллл[3C[7A[0m"
set "chr[8]=[Cлллллл[C[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8D[Cлллллл[C[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8D[Cлллллл[C[7A[0m"
set "chr[9]=[Cлллллл[C[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8Dл[6Cл[1B[8D[Cллллллл[1B[8D[6C[Cл[1B[8Dл[6Cл[1B[8D[Cлллллл[C[7A[0m"
set "chr[_]=[6C[2C[1B[8D[6C[2C[1B[8D[6C[2C[1B[8D[6C[2C[1B[8D[6C[2C[1B[8D[6C[2C[1B[8D[6C[2C[1B[8D        [7A[0m"
set "chr[.]=лллллллл[1B[8Dлллллллл[1B[8Dлллллллл[1B[8Dлллллллл[1B[8Dлллллллл[1B[8Dлллллллл[1B[8Dлллллллл[1B[8Dлллллллл[7A[0m"
set "tile[grass][0]=[38;2;8;222;36mлллллллл[B[8D[38;2;0;139;94mл[38;2;8;222;36mллл[38;2;0;139;94mл[38;2;8;222;36mллл[B[8D[38;2;0;139;94mлл[38;2;8;222;36mл[38;2;0;139;94mллл[38;2;8;222;36mл[38;2;0;139;94mл[B[8D[38;2;165;85;62mл[38;2;8;222;36mл[38;2;0;139;94mл[38;2;165;85;62mллл[38;2;0;139;94mл[38;2;165;85;62mл[B[8D[38;2;165;85;62mл[38;2;8;222;36mл[38;2;0;139;94mл[38;2;165;85;62mл[38;2;124;38;77mл[38;2;165;85;62mллл[B[8D[38;2;165;85;62mл[38;2;0;139;94mл[38;2;165;85;62mлллллл[B[8D[38;2;165;85;62mллллл[38;2;110;125;164mл[38;2;165;85;62mлл[B[8D[38;2;165;85;62mл[38;2;254;168;0mл[38;2;165;85;62mлллллл[7A[0m"
set "tile[grass][1]=[38;2;8;222;36mлллллллл[B[8D[38;2;8;222;36mлллл[38;2;0;139;94mл[38;2;8;222;36mллл[B[8D[38;2;0;139;94mл[38;2;8;222;36mлл[38;2;0;139;94mлл[38;2;8;222;36mллл[B[8D[38;2;0;139;94mл[38;2;8;222;36mлл[38;2;0;139;94mл[38;2;165;85;62mл[38;2;0;139;94mл[38;2;8;222;36mл[38;2;0;139;94mл[B[8D[38;2;0;139;94mл[38;2;8;222;36mл[38;2;0;139;94mл[38;2;165;85;62mллл[38;2;0;139;94mл[38;2;165;85;62mл[B[8D[38;2;165;85;62mл[38;2;0;139;94mл[38;2;165;85;62mллл[38;2;254;168;0mл[38;2;0;139;94mлл[B[8D[38;2;165;85;62mлллллллл[B[8D[38;2;165;85;62mлл[38;2;110;125;164mл[38;2;165;85;62mллл[38;2;249;206;164mл[38;2;165;85;62mл[7A[0m"
set "tile[grass][2]=[38;2;8;222;36mлллллллл[B[8D[38;2;0;139;94mл[38;2;8;222;36mл[38;2;0;139;94mллл[38;2;8;222;36mлл[38;2;0;139;94mл[B[8D[38;2;0;139;94mлл[38;2;165;85;62mлл[38;2;0;139;94mл[38;2;8;222;36mл[38;2;0;139;94mл[38;2;165;85;62mл[B[8D[38;2;165;85;62mллллл[38;2;8;222;36mл[38;2;0;139;94mл[38;2;165;85;62mл[B[8D[38;2;165;85;62mл[38;2;254;168;0mл[38;2;165;85;62mллл[38;2;0;139;94mл[38;2;8;222;36mл[38;2;165;85;62mл[B[8D[38;2;165;85;62mллллл[38;2;8;222;36mл[38;2;0;139;94mл[38;2;165;85;62mл[B[8D[38;2;165;85;62mллл[38;2;94;85;80mл[38;2;165;85;62mл[38;2;0;139;94mл[38;2;165;85;62mлл[B[8D[38;2;165;85;62mлллллллл[7A[0m"
set "tile[grass][3]=[38;2;8;222;36mлллллллл[B[8D[38;2;8;222;36mллллл[38;2;0;139;94mлл[38;2;8;222;36mл[B[8D[38;2;0;139;94mлл[38;2;8;222;36mллл[38;2;0;139;94mл[38;2;165;85;62mл[38;2;0;139;94mл[B[8D[38;2;165;85;62mл[38;2;0;139;94mл[38;2;8;222;36mлл[38;2;0;139;94mл[38;2;165;85;62mллл[B[8D[38;2;165;85;62mлл[38;2;0;139;94mл[38;2;8;222;36mл[38;2;0;139;94mл[38;2;165;85;62mллл[B[8D[38;2;165;85;62mллл[38;2;0;139;94mл[38;2;165;85;62mлл[38;2;124;38;77mл[38;2;165;85;62mл[B[8D[38;2;165;85;62mл[38;2;254;168;0mл[38;2;165;85;62mлллллл[B[8D[38;2;165;85;62mлллл[38;2;255;118;167mл[38;2;165;85;62mллл[7A[0m"
goto :eof

:buildSketch
if exist Sketch.bat goto :eof
for %%i in (
"QGVjaG8gb2ZmICYgc2V0bG9jYWwgZW5hYmxlRGVsYXllZEV4cGFuc2lvbg0KDQpz"
"ZXQgInJldmlzaW9uUmVxdWlyZWQ9My4yOS41Ig0Kc2V0ICAiKD0oc2V0ICJcPT8i"
"ICYgcmVuICIlfm54MCIgLXQuYmF0ICYgcmVuICI/LmJhdCIgIiV+bngwIiINCnNl"
"dCAiKT1yZW4gIiV+bngwIiAiXl4hXF5eIS5iYXQiICYgcmVuIC10LmJhdCAiJX5u"
"eDAiKSIgJiBzZXQgInNlbGY9JX5ueDAiDQpzZXQgImZhaWxlZExpYnJhcnk9cmVu"
"IC10LmJhdCAiJX5ueDAiICZlY2hvICBNaXNzaW5nIExpYnJhcnkuYmF0IFJlcXVp"
"cmVkIFJldmlzaW9uOiVyZXZpc2lvblJlcXVpcmVkJSAmIHRpbWVvdXQgL3QgMyAm"
"IGV4aXQiDQooJSg6Pz1MaWJyYXJ5JSAmJiAoY2FsbCA6cmV2aXNpb24pfHwoJWZh"
"aWxlZExpYnJhcnklKSkyPm51bA0KCWNhbGwgOnN0ZGxpYiAvdzoxNTAgL2g6MjAg"
"L3RpdGxlOiJNeSB0aXRsZSIgL2ZzOjE4IC9yZ2I6IjA7MDswIjoiMjU1OzI1NTsy"
"NTUiIC8zcmRwYXJ0eQ0KJSklICAmJiAoY2xzJmdvdG8gOnNldHVwKQ0KOnNldHVw"
"DQpSRU0gWW91ciBjb2RlIGhlcmUNCnBhdXNlICYgZXhpdA=="
) do echo %%~i>>"encodedSketch.txt"
certutil -decode "encodedSketch.txt" "Sketch.bat"
del /q /f "encodedSketch.txt"
goto :eof

:init_setfont DONT CALL
:: - BRIEF -
::  Get or set the console font size and font name.
:: - SYNTAX -
::  %setfont% [fontSize [fontName]]
::    fontSize   Size of the font. (Can be 0 to preserve the size.)
::    fontName   Name of the font. (Can be omitted to preserve the name.)
:: - EXAMPLES -
::  Output the current console font size and font name:
::    %setfont%
::  Set the console font size to 14 and the font name to Lucida Console:
::    %setfont% 14 Lucida Console
setlocal DisableDelayedExpansion
set setfont=for /l %%# in (1 1 2) do if %%#==2 (^
%=% for /f "tokens=1,2*" %%- in ("? ^^!arg^^!") do endlocal^&powershell.exe -nop -ep Bypass -c ^"Add-Type '^
%===% using System;^
%===% using System.Runtime.InteropServices;^
%===% [StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)] public struct FontInfo{^
%=====% public int objSize;^
%=====% public int nFont;^
%=====% public short fontSizeX;^
%=====% public short fontSizeY;^
%=====% public int fontFamily;^
%=====% public int fontWeight;^
%=====% [MarshalAs(UnmanagedType.ByValTStr,SizeConst=32)] public string faceName;}^
%===% public class WApi{^
%=====% [DllImport(\"kernel32.dll\")] public static extern IntPtr CreateFile(string name,int acc,int share,IntPtr sec,int how,int flags,IntPtr tmplt);^
%=====% [DllImport(\"kernel32.dll\")] public static extern void GetCurrentConsoleFontEx(IntPtr hOut,int maxWnd,ref FontInfo info);^
%=====% [DllImport(\"kernel32.dll\")] public static extern void SetCurrentConsoleFontEx(IntPtr hOut,int maxWnd,ref FontInfo info);^
%=====% [DllImport(\"kernel32.dll\")] public static extern void CloseHandle(IntPtr handle);}';^
%=% $hOut=[WApi]::CreateFile('CONOUT$',-1073741824,2,[IntPtr]::Zero,3,0,[IntPtr]::Zero);^
%=% $fInf=New-Object FontInfo;^
%=% $fInf.objSize=84;^
%=% [WApi]::GetCurrentConsoleFontEx($hOut,0,[ref]$fInf);^
%=% If('%%~.'){^
%===% $fInf.nFont=0; $fInf.fontSizeX=0; $fInf.fontFamily=0; $fInf.fontWeight=0;^
%===% If([Int16]'%%~.' -gt 0){$fInf.fontSizeY=[Int16]'%%~.'}^
%===% If('%%~/'){$fInf.faceName='%%~/'}^
%===% [WApi]::SetCurrentConsoleFontEx($hOut,0,[ref]$fInf);}^
%=% Else{(''+$fInf.fontSizeY+' '+$fInf.faceName)}^
%=% [WApi]::CloseHandle($hOut);^") else setlocal EnableDelayedExpansion^&set arg=
endlocal &set "setfont=%setfont%"
if !!# neq # set "setfont=%setfont:^^!=!%"
exit /b

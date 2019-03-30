@echo off & setlocal enableDelayedExpansion

for /F %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
set /a "hei=wid=100"
mode %wid%,%hei%

set "pointDistance=1"
(for %%a in ("d[7]=-%pointDistance% -%pointDistance%" "d[8]=0 -%pointDistance%" "d[9]=%pointDistance% -%pointDistance%"
			 "d[4]=-%pointDistance% 0"                "d[5]=0 0"                "d[6]=%pointDistance% 0"
			 "d[1]=-%pointDistance% %pointDistance%"  "d[2]=0 %pointDistance%"  "d[3]=%pointDistance% %pointDistance%" ) do (
	for /f "tokens=1-3 delims== " %%0 in ("%%~a") do set "%%0=dx[#]+=%%1", "dy[#]+=%%2""
))

set "map=[s[0C[38;5;10mлллллллллллллллллллллллллллллллллллллллллллллллллллл[0m[1B[52D[38;5;10mл[0m[7C[38;5;10mл[0m[42C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[7C[38;5;10mл[0m[42C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[7C[38;5;10mл[0m[42C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[7C[38;5;10mл[0m[42C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[7C[38;5;10mллллллллл[0m[12C[38;5;10mллллллллллллллллллллллл[0m[1B[52D[38;5;10mл[0m[28C[38;5;10mл[0m[21C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[28C[38;5;10mл[0m[21C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[28C[38;5;10mл[0m[21C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[28C[38;5;10mл[0m[21C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[28C[38;5;10mл[0m[21C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[28C[38;5;10mл[0m[21C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[28C[38;5;10mл[0m[21C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[28C[38;5;10mл[0m[21C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[14C[38;5;10mллллллллллллллл[0m[21C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[39C[38;5;10mл[0m[10C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[39C[38;5;10mл[0m[10C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[39C[38;5;10mл[0m[10C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[39C[38;5;10mл[0m[10C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[14C[38;5;10mллллллллллллллл[0m[10C[38;5;10mл[0m[10C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[50C[38;5;10mл[0m[1B[52D[38;5;10mл[0m[7C[38;5;10mлллллллллллллллллллллллллллллллллллллллллллл[0m[8[u"
set "temp=%map:=%" & (for %%t in ("[= [" "[38;5;10m=" "[0m=" "[s=" "[u=" "[8=" "л=л " "[=" "  = " "  = ") do set "temp=!temp:%%~t!") & set "temp=!temp:~1!"
set /a "mx=1","my=1" & for %%a in (%temp%) do (
	set "current=%%a"
	if "!current!" equ "л" (
		set /a "mx+=1", "collisions+=1"
		set "collisionX[!collisions!]=!mx!"
		set "collisionY[!collisions!]=!my!"
	) else     if !current:~-1! equ B ( set /a "my+=!current:~0,-1!"
		) else if !current:~-1! equ C ( set /a "mx+=!current:~0,-1!"
		) else if !current:~-1! equ D ( set /a "mx-=!current:~0,-1!"
	)
)

set /a "dx[1]=50", "dy[1]=50" & set "screen=!screen!%esc%[!dy[1]!;!dx[1]!Hл"
for /l %%# in () do (
	<nul set /p "=%esc%[?25l%esc%[2J%esc%[0;0H%map%!screen!" & set "screen="
	for /f "tokens=*" %%m in ('choice /c:123456789 /n') do (
		set "disectMove=!d[%%m]!" & set "disectMove=!disectMove:"=!"
		for %%d in (",=" "dx[#]=" "dy[#]=" "+=") do set "disectMove=!disectMove:%%~d!"
		for /f "tokens=1,2 delims==" %%d in ("!disectMove!") do set /a "testX=dx[1] + %%d", "testY=dy[1] + %%e"
		for /l %%a in (1,1,%collisions%) do if !testY! equ !collisionY[%%a]! if !testX! equ !collisionX[%%a]! set "collide=1"
		if !collide! neq 1 set /a "!d[%%m]:#=1!"
	)
	set "collide=0"
	set "screen=!screen!%esc%[!dy[1]!;!dx[1]!Hл"
)
pause >nul & exit

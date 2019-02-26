:macros
set ^"LF=^

^" Above empty line is required - do not remove
set ^"\n=^^^%LF%%LF%^%LF%%LF%^^"
for /F %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"
<nul set /p "=!esc![?25l"

rem %RGBplot% x y 0-255 0-255 0-255 CHAR
set RBGplot=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
  set "screen=^!screen^!!esc![%%2;%%1H!esc![38;2;%%3;%%4;%%5m?!esc![0m"%\n%
)) else set args=

rem %point% x y
set point=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-2" %%1 in ("^!args^!") do (%\n%
	set "screen=^!screen^!!esc![%%2;%%1H?!esc![0m"%\n%
)) else set args=
  
rem %plot% x y 0-255 CHAR
set plot=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4" %%1 in ("^!args^!") do (%\n%
	set "screen=^!screen^!!esc![%%2;%%1H!esc![38;5;%%3m%%~4!esc![0m"%\n%
)) else set args=

rem %getDistance% x2 x1 y2 y1 RETURNVAR
set getDistance=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	set /a "%%5=( ?=((((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4))))>>31)+1, ?*(2*((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4)))-(((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4))))) + ^^^!?*(((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4)))-(((((%%1 - %%2))>>31|1)*((%%1 - %%2)))-((((%%3 - %%4))>>31|1)*((%%3 - %%4)))*2)) )"%\n%
)) else set args=

rem circle x y r color char
set circle=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
		if "%%~4" equ "" ( set "hue=30" ) else ( set "hue=%%~4")%\n%
        for /l %%y in (-%%3,1,%%3) do for /l %%x in (-%%3,1,%%3) do (%\n%
            set /a "_S=(%%x * %%x) + (%%y * %%y) - (%%3 * %%3)", "_3div2=%%3 / 2", "tx=%%x+%%1", "ty=%%y+%%2"%\n%
			for /f "tokens=1-5" %%a in ("^!_S^! ^!_3div2^! ^!tx^! ^!ty^! ^!hue^!") do (%\n%
				if %%a geq -%%3 if %%a leq %%b ( ^!plot^! %%c %%d %%e %%~5)%\n%
		))%\n%
        set "s="%\n%
)) else set args=

rem %fastCircle% x y ch cw color
set fastCircle=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-7" %%1 in ("^!args^! sin^(x^) cos^(x^)") do (%\n%
	for /l %%a in (0,30,360) do (%\n%
		set /a "xa=%%~3 * ^!%%~7:x=%%a^! + %%~1"%\n%
		set /a "ya=%%~4 * ^!%%~6:x=%%a^! + %%~2"%\n%
		for /f "tokens=1,2" %%x in ("^!xa^! ^!ya^!") do ^!plot^! %%x %%y %%~5 U%\n%
	)%\n%
)) else set args=

rem line x1 y1 x2 y2 color
set line=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	if "%%~5" equ "" ( set "hue=30" ) else ( set "hue=%%~5")%\n%
	set /a "xa=%%~1", "ya=%%~2", "xb=%%~3", "yb=%%~4", "dx=%%~3 - %%~1", "dy=%%~4 - %%~2"%\n%
	for /f "tokens=1-2" %%6 in ("^!dx^! ^!dy^!") do (%\n%
		if %%~7 lss 0 ( set /a "dy=-%%~7", "stepy=-1" ) else ( set "stepy=1" )%\n%
		if %%~6 lss 0 ( set /a "dx=-%%~6", "stepx=-1" ) else ( set "stepx=1" )%\n%
		set /a "dx<<=1", "dy<<=1"%\n%
	)%\n%
	for /f "tokens=1-9" %%a in ("^!dx^! ^!dy^! ^!xa^! ^!xb^! ^!ya^! ^!yb^! ^!stepx^! ^!stepy^! ^!hue^!") do (%\n%
		if %%~a gtr %%~b (%\n%
			set /a "fraction=%%~b - (%%~a >> 1)"%\n%
			for /l %%x in (%%~c,%%~g,%%~d) do (%\n%
				for /f "tokens=1" %%6 in ("^!fraction^!") do if %%~6 geq 0 set /a "ya+=%%~h", "fraction-=%%~a"%\n%
				set /a "fraction+=%%~b"%\n%
				for /f "tokens=1" %%6 in ("^!ya^!") do ^!plot^! %%x %%~6 %%i U%\n%
			)%\n%
		) else (%\n%
			set /a "fraction=%%~a - (%%~b >> 1)"%\n%
			for /l %%y in (%%~e,%%~h,%%~f) do (%\n%
				for /f "tokens=1" %%6 in ("^!fraction^!") do if %%~6 geq 0 set /a "xa+=%%~g", "fraction-=%%~b"%\n%
				set /a "fraction+=%%~a"%\n%
				for /f "tokens=1" %%6 in ("^!xa^!") do ^!plot^! %%~6 %%y %%i U%\n%
			)%\n%
		)%\n%
	)%\n%
)) else set args=


rem arc x y size DEGREES(0-360) lineThinness arcRotationDegrees(0-360) color
set arc=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-7" %%1 in ("^!args^!") do (%\n%
	if "%%~7" equ "" ( set "hue=30" ) else ( set "hue=%%~7")%\n%
	set /a "arc=%%~4 + %%~6"%\n%
    for /f "tokens=1-4" %%a in ("^!arc^! sin^(x^) cos^(x^) ^!hue^!") do for /l %%e in (%%~6,%%~5,%%~a) do (%\n%
		set /a "_x=%%~3 * ^!%%~c:x=%%~e^! + %%~1", "_y=%%~3 * ^!%%~b:x=%%~e^! + %%~2"%\n%
		for /f "tokens=1,2" %%X in ("^!_x^! ^!_y^!") do ^!plot^! %%~X %%~Y %%d U%\n%
	)%\n%
)) else set args=

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
	for /f "tokens=1-3" %%a in ("^!R^! ^!G^! ^!B^!") do ^!RBGplot^! %%1 %%2 %%a %%b %%c%\n%
)) else set args=

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
	for /f "tokens=1-3" %%a in ("^!R^! ^!G^! ^!B^!") do ^!RBGplot^! %%1 %%2 %%a %%b %%c%\n%
)) else set args=

rem %ifAnd% value LO HI RETURNVAR
set ifAnd=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4" %%1 in ("^!args^!") do (%\n%
	set /a "aux=(%%~2-%%~1)*(%%~1-%%~3), %%~4=(aux-1)/aux"%\n%
)) else set args=

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

rem MAP using smoothStep algorithm
rem smoothStep min max X RETURNVAR
set smoothStep=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-4" %%1 in ("^!args^!") do (%\n%
	%= Scale, bias and saturate x to 0..100 range =%%\n%
	set /a "clamped=((%%3) - %%1) * 100 ^/ (%%2 - %%1) + 1"%\n%
	for /f "tokens=1" %%c in ("^!clamped^!") do ^!clamp^! %%c 0 100 CLAMPED_x %\n%
	%= Evaluate polynomial =%%\n%
	set /a "ss=^(3*100 - 2 * CLAMPED_x^) * CLAMPED_x^/100 * CLAMPED_x^/100"%\n%
	for /f "tokens=1" %%x in ("^!ss^!") do (%\n%
		if "%%4" neq "" ( set "%%4=%%x" ) else ( echo=%%x)%\n%
	)%\n%
)) else set args=

rem FNcross x1 y1 x2 y2 RETURNVAR
set FNcross=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	set /a "%%~5=%%~1*%%~4 - %%~2*%%~3"%\n%
)) else set args=

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

rem %RGBplot% x y 0-255 0-255 0-255 CHAR
set RBGplot=for %%# in (1 2) do if %%#==2 ( for /f "tokens=1-5" %%1 in ("^!args^!") do (%\n%
	set "screen=^!screen^!!esc![%%2;%%1H!esc![38;2;%%3;%%4;%%5mU!esc![0m"%\n%
)) else set args=

rem RGBline x1 y1 x2 y2 0-360 0-10000 0-10000
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
goto :eof

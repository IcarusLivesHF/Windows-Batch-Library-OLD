    Revision 4.0.0                  + added     - removed     * fixed     # changed     / moved
------------------------------------------------------------------------------------------------------------------------------------------
	Change Log:

		+ Redesigned the library where its entirely controlled by :stdlib. As always, you can use the
			arguments in any order you want. If you realize later you need one, you don't need to remember
			any particular order. You only need to remember which /tags do what.
		+ L.32bit
		+ rem[
		+ rem+
		+ sort[fwd]
		+ sort[rev]
		+ filter[fwd]
		+ filter[rev]
		+ /extlib provides several new special characters

		# No longer accepts older revisions. Revision must now be same as requiredRevision.
		# %sin% - optimized
		# %cos% - optimized
		# %countLoops% renamed to %frames%

		/ %loop% to /util
		/ %throttle% to /util
		/ %frames% to /util
		
		* fixed a bug where sin and cos weren't expanding properly from /math
		* fixed a bug where backgroundColor and textColor needed to be expanded in /rgb
		* fixed a bug where range needed to be expanded in /cr

------------------------------------------------------------------------------------------------------------------------------------------

	The Window Batch Library is a collection of pre-written batch scripts that can be used 
    to simplify and speed up the process of creating command-line interfaces (CLIs) and other 
    types of text-based user interfaces (TUIs). The library includes a wide range of functions 
    and macros, including standard console manipulations, mathematical calculations, color and 
    text formatting, and mouse input.

    Overall, the Window Batch Library is a powerful tool for anyone looking to create 
    command-line interfaces or other types of text-based user interfaces using Windows Batch 
    scripting. By providing a range of pre-written functions and macros, the library can help 
    streamline the development process and make it easier to create complex and powerful 
    applications using the command line.

    Open the library by substituting '?' with the name of the library in the variable %(%
    and check if the required revision OR LESS is being used. If everything checks out,
    it will CALL :FUNCTIONS from INSIDE the "Library.bat."

	Library.bat contains many labels, but not all of them are intended to be called, rather than
	they are book markers when using Notepad++. Clicking the "fx" button on the top menu bar will
	display all of the "book marks" as well as labels intended to be called by the user. 
	Be mindful of the documentation below, as well as the "DON'T CALL" next to the labels that are
	not intended to be called. Thanks <3


------------------------------------------------------------------------------------------------------------------------------------------
@echo off & setlocal enableDelayedExpansion & set "(=(set "\=?" & ren "%~nx0" -t.bat & ren "?.bat" "%~nx0"" & set ")=ren "%~nx0" "^^!\^^!.bat" & ren -t.bat "%~nx0")" & set "self=%~nx0" & set "failedLibrary=ren -t.bat "%~nx0" &echo Library not found & timeout /t 3 & exit"

set "revisionRequired=X.X.X"
(%(:?=Library% && (call :revision)||(%failedLibrary%))2>nul
    call :stdlib /w:N /h:N /fs:N /title:"foobar" /rgb:"foo":"bar" /debug /extlib /3rdparty /multi /sprite /math /misc /shape /ac /turtle /cursor /cr:N /8x8 /gfx /util
%)%  && (cls&goto :setup)

:setup

pause & exit
------------------------------------------------------------------------------------------------------------------------------------------
    CALL :STDLIB <arguments CAN BE IN ANY ORDER YOU WANT>
	
	STDLIB provides the following variables for you to use.
		%pixel%        - Û character
		%.%            - Û character
		%esc%          - esc character  Example: echo %esc%[5;5HHello World
		%\e%           - esc[           Example: echo %\e%5;5HHello World
		%\p%           - 'echo %esc%['  Example: %/p%5;5HHello World
		%cls%          - echo or <nul set /p "=" to clear screen NOT the same as CLS
		%\c%           - same as %cls%                           NOT the same as CLS
		%\rgb%         - sets the color code from %R% %G% %B% to TEXT color if defined.
		%\fcol%        - sets the color code from %R% %G% %B% to BACKGROUND color if defined.
		%\n%           - new line
		%L.32bit%      - 2147483647 CONSTANT - 32bit limit
		Hides cursor

------------------------------------------------------------------------------------------------------------------------------------------
    /w:N           -  set width  of console, returns %wid%, %width%

------------------------------------------------------------------------------------------------------------------------------------------
    /h:N           -  set height of console, returns %hei%, %height%

------------------------------------------------------------------------------------------------------------------------------------------
    /fs:N          - font size (5-100). The default font style used is TERMINAL

------------------------------------------------------------------------------------------------------------------------------------------
    /title /t:""   - speaks for itself, but make sure its surrounded in quotes ""

------------------------------------------------------------------------------------------------------------------------------------------
    /extlib /e     - provides the backspace(BS), BEL, CR, and TAB characters as variables

------------------------------------------------------------------------------------------------------------------------------------------
    /rgb           - must surroud your color codes in quotes ""

------------------------------------------------------------------------------------------------------------------------------------------
    /3rdparty /3rd - IF %temp%/batch does not exist on current machine,
        puts the following tools insides the folder

            a. curl.exe
            b. nircmd.exe
            c. wget.exe
            d. inject.exe ( tool used to inject getinput.dll into cmd )
            e. getinput.dll ( non-blocking input tool for mouse postion, clicks, and keypresses )
            f. mouse.exe

        /3rdparty also provides the current variables as macros for however you want to use them

                USE AS COMMANDS

            a. %curl% <CURL SYNTAX>
            b. %nircmd% <NIRCMD SYNTAX>
            c. %wget% <WGET SYNTAX>
            d. %import_getInput.dll% - the moment this is called, you can use
                d.1. mouseXpos
                d.2. mouseYpos
                d.3. keypressed
                d.4. click <rtns 1-2 or nothing>
            e. %getMouseXY% - use mouse.exe to capture the following
                e.1. mouseX
                e.2. mouseY
                e.3. mouseC
            f. %clearMouse% to set e.1-3. = 0

    /debug /d      - turns on debug mode, echo is ON, font is larger, font set to consolas
        for readability, and a larger console size to see all the code in one spot. 
        I find this argument useful when debugging new macros for the library.

------------------------------------------------------------------------------------------------------------------------------------------
    /CURSOR /c <no arguments> - Provides the following variables to be used in set /a using substitution. EX: echo %cursor[D]:?=1%
		%>%               - <nul set /p "=" but less to type.
		All of these here must be echo'd or %>%
		%push%            - save current x y postion
		%pop%             - return to saved x y postion
		%cursor[U]:?=NUM% - change NUM to amount you want cursor to move UP
		%cursor[D]:?=NUM% - change NUM to amount you want cursor to move DOWN
		%cursor[L]:?=NUM% - change NUM to amount you want cursor to move LEFT
		%cursor[R]:?=NUM% - change NUM to amount you want cursor to move RIGHT
		%cac%             - clear above cursor
		%cbc%             - clear below cursor
		%underline%       - use prior to echoing something you want underlined. EX: echo %underline%Hello World
		%capit%           - stops colorizing, underlines, or all string attributes by vt100
		%moveXY%          - sets cursor to postition x,y if defined.
		%home%            - sets cursor to 0,0
		%setDefaultColor% - no need to echo. Will set console color to initial set during library load.
		%setStyle% - 1 arguement. RGB or BIT. RGB(2) will expect "r;g;b" as a color code where as BIT(5)
			will expect 0-255 as a color code.

------------------------------------------------------------------------------------------------------------------------------------------
    /MATH <no arguments> - Provides the following variables to be used in set /a using substitution. EX: set /a "dx=10 * %SIN:x=ANGLE%"

		%PI%                -  31416 CONSTANT
		%HALF_PI%           -  15708 CONSTANT
		%TWO_PI%            -  62832 CONSTANT
		%PI32%              -  47124 CONSTANT
		%NEG_PI%            - -31416 CONSTANT
		%NEG_HALF_PI%       - -15708 CONSTANT
		%SIN%               - provide x as  theta/angle as 0-360
		%COS%               - provide x as theta/angle as 0-360
		%SINR%              - provide x as theta/angle as 0-TWO_PI
		%COSR%              - provide x as theta/angle as 0-TWO_PI
		%sqrt(N)%           - provide N get square root of N
		%sign%              - provide x get sign of x
		%abs%               - provide x get absolute value of x
		%dist(x2,x1,y2,y1)% - get distance from one point to another.
		%avg%               - return average or x and y 
		%map%               - v = value to change, a = v-FROM, b = v-TO, c = v-DESIRED-FROM, d = v-DESIRED-TO
							   EX: set /a "v=5", "a=0", "b=10", "c=100", "d=200", "output=%map%"
		%lerp%              - provide a, b, c, refer to: https://en.wikipedia.org/wiki/Linear_interpolation
		%swap%              - provided x and y are defined, swap them
		%getState%          - provide a, b, c, d, returns 0-15
		%percentOf%         - provide x, y as X percent of Y. EX set /a "x=76, y=83", "out=%percentOf%" %out% = 63. True answer is 63.08.
		%min%               - provide x, y returns smaller integer
		%max%               - provide x, y returns larger  integer

------------------------------------------------------------------------------------------------------------------------------------------
    /MISC <no arguments> - Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%

		%gravity%           - substitute ? for affected variable
								accerlation increases by 1 per frame,
								  velocity increases by accerlation per frame,
								  Y position is increased by velocity per frame
							provides as variables:
								%_G_%             - Gravity added to Accerlation
								%?.acceleration%  - Acceleration add to Velocity
								%?.velocity%      - Velocity added to substituted ?
		%chance%            - provide x. requires 2>nul redirection, but works as such.
							   EX: set /a "%chance:x=25%" && ( echo 25 percent chance ) || ( echo 75 percent chance )
		%every%             - provide x  MUST ITERATE frameCount+=1 EX: set /a "%every:x=frameCount%" && ( code )
		%smoothStep%        - provide x
		%bitcolor%          - translate R G B to BITCOLOR
		%ifOdd%             - provide x  EX:  set /a "%ifOdd:x=3%" && ( code )
		%ifEven%            - provide x  EX:  set /a "%ifEven:x=3%" && ( code )
		%RCX%               - provide x returns 1 if 0 < x < wid  EX:  set /a "%RCX:x=-10%" || ( code )
		%RCY%               - provide x returns 1 if 0 < x < hei  EX:  set /a "%RCY:x=-10%" || ( code )
		%edgeCase%          - provide x, y returns 1 if 0 < x & y < wid & hei   EX:  set /a "%edgeCase%" && ( code )
		%rndBetween%        - provide x  get a random number between -x and x
		%fib%               - returns fibonacci sequence
		%mouseBound%        - provide ma, mb, mc, md as edge cases to mouse clicks.

------------------------------------------------------------------------------------------------------------------------------------------
    /SHAPES /sh <no arguments> - Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%

		%SQ(x)%             - provide x         - returns x^2 or area of square.
		%CUBE(x)%           - provide x         - returns x^3 or area of cube
		%pmSQ(x)%           - provide x         - returns x * 4
		%pmREC(l,w)%        - provide l, w      - returns l * 2 + w * 2
		%pmTRI(a,b,c)%      - provide a, b, c   - returns a + b + C
		%areaREC(l,w)%      - provide l, w      - returns l * w
		%areaTRI(b,h)%      - provide b, h      - returns b * h / 2
		%areaTRA(b1,b2,h)%  - provide b1, b2, h - returns b1 * b2 * h / 2
		%volBOX(l,w,h)%     - provide l, w, h   - returns l * w * h

------------------------------------------------------------------------------------------------------------------------------------------
    /ac <no arguments>  ALGORITHMIC CONDITIONS - Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%

		%LSS(x,y)%             - provide x, y         - <
		%LEQ(x,y)%             - provide x, y         - <=
		%GTR(x,y)%             - provide x, y         - >
		%GEQ(x,y)%             - provide x, y         - >=
		%EQU(x,y)%             - provide x, y         - ==
		%NEQ(x,y)%             - provide x, y         - !=
		%AND(b1,b2)%           - provide b1, b2       - &&
		%OR(b1,b2)%            - provide b1, b2       - ||
		%XOR(b1,b2)%           - provide b1, b2       - ^
		%TERN(bool,v1,v2)%     - provide bool, v1, v2 - ?:

------------------------------------------------------------------------------------------------------------------------------------------
    /turtle X Y THETA/ANGLE - Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%

		Current position is x=%~1, y=%~2, facingDirection(0-360)=%~3

		%forward%       - upon execution, sub ? for 1-n    EX: %forward:?=1%
		%turnLeft%      - upon execution, sub ? for 0-360  EX: %turnLeft:?=1%
		%turnRight%     - upon execution, sub ? for 0-360  EX: %turnRight:?=1%
		%TF_push%       - save turtle position
		%TF_pop%        - return to saved turtle position
		%draw%          - %draw:?=VARIABLE% will write dfx dfy dfa to VARIABLE - NOT MATH
		%home%          - sends turtle home
		%cent%          - sends turtle to middle screen
		%penDown%       - draw while the turtle moves  EX: %pendown:#=1%  - NOT MATH

		Default turtle display variable in penDown is turtleGraphics. %turtleGraphics%

------------------------------------------------------------------------------------------------------------------------------------------
	/sprites /s <no arguments>
		Currently only provides:
			%ball[0]% - Ball sprite made from " " color using background colors
			%ball[1]% - Ball sprite made from "Û" color using text colors

------------------------------------------------------------------------------------------------------------------------------------------
	/multi <no arguments>
		Provides the following macro:
			%fetchDataFromController%

		Sets %controller% = True

------------------------------------------------------------------------------------------------------------------------------------------
    /cr <1-255> - Provides array of colors sorted in RGB in color[]

		Use %totalColorsInRange% (CONSTANT) to get the max out the the color[] array
		Also provides %range% (CONSTANT) which is 255 / %~1

------------------------------------------------------------------------------------------------------------------------------------------
    /gfx <no arguments> Provides functions for gfx work

	%frames%            - use with set /a to get %frameCount% Example: set /a "%frames%"

	%loop%              - begin infinite loop 
                            (NOT A MATH OPERATION) SEE LINE: :MISC/loop in Library.bat

	%framedLoop%        - infinite loop that counts and loops at the 32bit limit
	
    %throttle%          - provide x to THROTTLE the script. (this can make animations that are too fast look better)
                            (NOT A MATH OPERATION) SEE LINE: :MISC/throttle in Library.bat

    %point%               - x y                                                                     <rtn> _scrn_
	    draws %pixel% at x y to %_scrn_%

    %plot%                - x y 0-255 CHAR                                                          <rtn> _scrn_
	    draws CHAR at x y to %_scrn_%

    %RGBpoint%            - x y 0-255 0-255 0-255 CHAR                                              <rtn> _scrn_
		draws CHAR at x y in color specified to %_scrn_%

    %translate%           - x Xoffset y Yoffset
		shift x and y by their offset

    %Bvector%             - name[ID] diameter character/sprite %~2 & %~3 not necessary              <rtn> %~1.x %~1.y %~1.td %~1.tr %~1.m %~1.i %~1.j %~1.rgb 
		creates vector[ID] with the following attributes
			x    - x position     1 to wid unless %~2 is provided where %~2 to wid-%~2
			y    - y position     1 to hei unless %~2 is provided where %~2 to hei-%~2
			td   - thetaDegrees   0 to 360
			tr   - thetaRadians   0 to 62832
			m    - magnitude      2 to 4
			i    - x increment   -2 to 2
			j    - y increment   -2 to 2
			rgb  - vectors color 0 to 255
			fcol - vectors color 0 to 255
			
			if %~2 is defined
				vd  - diameter
				vr  - radius
				vmw - vectors Max Width
				vmh - vectors Max Height
				
			if %~3 is defined
				ch  - character or spriteVariable
		usage:
			%Bvector% this
			echo %this.x% %this.y% %this.td% %this.tr% %this.m% %this.i% %this.j%
			echo %this.rgb% %this.fcol% %this.vd% %this.vr% %this.vmw% %this.vmh% %this.ch%

    %lerpRGB%             - 1 2 (1-100:blend amount)                                                 <rtn> $r $g $b
		blend two RGB values together using r[] g[] b[]
		%~1 - r[1] g[1] b[1]
		%~2 - r[2] g[2] b[2]
		%~3 - blend amount

    %getDistance%         - x2 x1 y2 y1                                                             <rtnVar> youNameIt
		get the distance between two points
		no need to define x2 x1 y2 y1 first like when using %dist% from :math

    %exp%                 - num pow                                                                 <rtnVar> youNameIt
		calculate exponents

    %circle%              - x y ch cw                                                               <rtn> $circle
		draw a circle to $circle at x y at the size of CHxCW

    %rect%                - x r wid hei                                                             <rtn> $rect
		draw a rectangle to $rect at x y the size of HEIxWID

    %line%                - x0 y0 x1 y1 color                                                       <rtn> $line
		draw a line to $line from x0 y0 to x1 y1

    %bezier%              - x1 y1 x2 y2 x3 y3 x4 y4 length                                          <rtn> $bezier
		draw a bezier curve from x1 y1, x2 y2, x3 y3, x4 y4 at your desired length

    %RGBezier%            - x1 y1 x2 y2 x3 y3 x4 y4 length                                          <rtn> $RGBezier
		draw a bezier curve from x1 y1, x2 y2, x3 y3, x4 y4 at your desired length
		works with :colorRange

    %arc%                 - x y size DEGREES(0-360) arcRotationDegrees(0-360) lineThinness color    <rtn> _scrn_
		draws an ARC on the screen

    %plot_HSL_RGB%        - x y 0-360 0-10000 0-10000                                               <rtn> _scrn_
		plot in HUE SATURATION LUMINOUSITY

    %plot_HSV_RGB%        - x y 0-360 0-10000 0-10000                                               <rtn> _scrn_
		plot in HUE SATURATION VALUE

    %clamp%               - x min max                                                               <rtnVar> youNameIt
		clamp x between MIN and MAX

    %map%                 - min max X                                                               <rtnVar> youNameIt
		map X to the range of min max

    %fncross%             - x1 y1 x2                                                                <rtnVar> youNameIt

    %intersect%           - x1 y1 x2 y2 x3 y3 x4 y4 <rtnVar> <rtnVar> - CROSS VECTOR PRODUCT algorithm

    %HSL_line%            - x1 y1 x2 y2 0-360 0-10000 0-10000                                       <rtn> _scrn_
		draw line using plot_HSL_RGB
------------------------------------------------------------------------------------------------------------------------------------------
	/util <no arguments> Provides functions for gfx work
	
	%sort[fwd]%           - sort a string forward

	%sort[rev]%           - sort a string backward

	%hexToRGB%            - '00a2ed' no quotes                                                      <rtn> R G B
		converts hex to to R G B values

    %getLen%              - "string"                                                                <rtn> $length
		get the length of a string

    %pad%                 - "string".int                                                            <rtn> $padding
		padding function to get nice spacing in "menus".

    %encode%              - "string"                                                                <rtn> base64
		encode a string in base64 using certutil

    %decode%              - %decode:?=!base64!%
		decode a given string in base64

	old name: $string_
    %string_properties%   - "string"                                                                <rtn> $_len, $_rev $_upp $_low
		use to get the length, reverse, upper, and lower version of the provided string

	old name: injectStringIntoFile
    %fart%  - %fart:?=FILE NAME.EXT% "String":LineNumber
		Use to inject/swap specific lines in files

    %getLatency%          -                                                                         <rtn> %latency%
		use to see your current ping
    %download%            - %url% %file%
		download a file via url

    %zip%                 - file.ext zipFileName
		zipping tool using TAR

    %unzip%               - zipFileName
		unzipping tool using TAR

    %license%             - "mySignature" NOTE: You MUST add at least 1 signature to your script ":::mySignature" without the quotes
		It is important that you do NOT add this to your code until you are COMPLETELY finished editiing it, and ready to release.

		This function calculates a magic number based on the script itself, and stores the value in a file in %temp%

		Once you add this to your script, AND RUN IT, you can NOT modify your script. It WILL delete itself.

		This is to protect the creators work from being tampered with. USE AT YOUR OWN RISK!!!

------------------------------------------------------------------------------------------------------------------------------------------
	/8x8 <no arguments> Provides user with character sprites
		Currently only provides:
			Letters A-Z(uppercase only) Example: echo %chr[-A]%
			Numbers 0-9                 Example: echo %chr[4]%
			Tile[grass][0-3]            Example: echo %tile[grass][0]% - May be removed. Too much data.

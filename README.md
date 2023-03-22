# Windows-Batch-Library

Over 100 functions to improve the usability of the Windows Batch Scripting Language.

CALL :STDLIB <ARGUEMENTS CAN BE IN ANY ORDER YOU WANT>
ECHO is off.
/w 		  -  set width  of console, returns %wid%, %width%
/h 		  -  set height of console, returns %hei%, %height%
/fs 	  - font size (5-100). The default font style used is TERMINAL
/title    - speaks for itself, but make sure its surrounded in quotes ""
/extlib   - provides the backspace(BS), BEL, CR, and TAB characters as variables
/rgb 	  - must surroud your color codes in quotes ""
/3rdparty - IF %temp%/batch does not exist on current machine,
	puts the following tools insides the folder
ECHO is off.
		a. curl.exe
		b. nircmd.exe
		c. wget.exe
		d. inject.exe ( tool used to inject getinput.dll into cmd )
		e. getinput.dll ( non-blocking input tool for mouse postion, clicks, and keypresses )
		f. mouse.exe
ECHO is off.
	/3rdparty also provides the current variables as macros for however you want to use them
ECHO is off.
			USE AS COMMANDS
ECHO is off.
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
ECHO is off.
/debug - turns on debug mode, echo is ON, font is larger, font set to consolas
	for readability, and a larger console size to see all the code in one spot. 
	I find this argument useful when debugging new macros for the library.
ECHO is off.
STDLIB provides the following variables for you to use.
ECHO is off.
%pixel% - Û character
%.% 	- Û character
%esc%   - esc character
%\e%    - esc character
%cls%   - echo or <nul set /p "=" to clear screen
%\c%	- same as %cls%
%\rgb%  - sets the color code from %R% %G% %B% if defined.
%\n% 	- new line
Hides cursor


CALL :CURSOR <no arguments>
ECHO is off.
Provides the following as macros.
ECHO is off.
%>% 			  - <nul set /p "=" but less to type.
ECHO is off.
All of these here must be echo'd or %>%
%push% 			  - save current x y postion
%pop% 			  - return to saved x y postion
%cursor[U]:?=NUM% - change NUM to amount you want cursor to move UP
%cursor[D]:?=NUM% - change NUM to amount you want cursor to move DOWN
%cursor[L]:?=NUM% - change NUM to amount you want cursor to move LEFT
%cursor[R]:?=NUM% - change NUM to amount you want cursor to move RIGHT
%cac%			  - clear above cursor
%cbc% 			  - clear below cursor
%underline%		  - use prior to echoing something you want underlined. EX: echo %underline%Hello World
%capit% 		  - stops colorizing, underlines, or all string attributes by vt100
%moveXY%		  - sets cursor to postition x,y if defined.
%home% 			  - sets cursor to 0,0
ECHO is off.
%setDefaultColor% - no need to echo. Will set console color to initial set during library load.
%setStyle% - 1 arguement. RGB or BIT. RGB(2) will expect "r;g;b" as a color code where as BIT(5)
	will expect 0-255 as a color code.
  
  
CALL :MATH <no arguments>
ECHO is off.
Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%
ECHO is off.
%PI%          -  31416
%HALF_PI%     -  15708
%TWO_PI%      -  62832
%PI32%        -  47124
%NEG_PI%      - -31416
%NEG_HALF_PI% - -15708
%SIN%		  - provide x as  theta/angle as 0-360
%COS% 		  - provide x as theta/angle as 0-360
%SINR%		  - provide x as theta/angle as 0-TWO_PI
%COSR% 		  - provide x as theta/angle as 0-TWO_PI
%sqrt(N)%	  - provide N
%sign%		  - provide x
%abs% 		  - provide x
%dist(x2,x1,y2,y1)% - get distance from one point to another.
%avg% 		  - return average or x and y 
%map%		  - v = value to change, a = v-FROM, b = v-TO, c = v-DESIRED-FROM, d = v-DESIRED-TO
				EX: set /a "v=5", "a=0", "b=10", "c=100", "d=200", "output=%map%"
%lerp% 		  - provide a, b, c, refer to: https://en.wikipedia.org/wiki/Linear_interpolation
%swap% 		  - provided x and y are defined, swap them
%getState% 	  - provide a, b, c, d, returns 0-15


CALL :MISC <no arguments>
ECHO is off.
Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%
ECHO is off.
%gravity% 		- accerlation increases by 1 per frame,
				  velocity increases by accerlation per frame,
				  Y position is increased by velocity per frame
%percentOf%		- provide x, y as X percent of Y. EX set /a "x=76, y=83", "out=%percentOf%" %out% = 63. True answer is 63.08.
%chance% 		- provide x. requires 2>nul redirection, but works as such.
					EX: set /a "%chance:x=25%" && ( echo 25 percent chance ) || ( echo 75 percent chance )
%every%			- provide x  EX: set /a "%every:x=frameCount%" && ( code )
%smoothStep% 	- provide x
%bitcolor% 		- translate R G B to BITCOLOR
%loop% 			- begin infinite loop
%throttle%		- provide x to THROTTLE the script. (this can make animations that are too fast look better)
%ifOdd% 		- provide x  EX:  set /a "%ifOdd:x=3%" && ( code )
%ifEven% 		- provide x  EX:  set /a "%ifEven:x=3%" && ( code )
%RCX% 			- provide x returns 1 if 0 < x < wid  EX:  set /a "%RCX:x=-10%" || ( code )
%RCY% 			- provide x returns 1 if 0 < x < hei  EX:  set /a "%RCY:x=-10%" || ( code )
%edgeCase% 		- provide x, y returns 1 if 0 < x & y < wid & hei   EX:  set /a "%edgeCase%" && ( code )
%rndBetween% 	- provide x  get a random number between -x and x
%fib%			- returns fibonacci sequence
%mouseBound% 	- provide ma, mb, mc, md as edge cases to mouse clicks.

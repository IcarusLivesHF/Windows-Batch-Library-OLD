rem this script is not intended to be ran.-----v


rem Open the library by substituting '?' with the name of the library in the variable %(%
rem  and check if the required revision OR LESS is being used. If everything checks out,
rem it will CALL :FUNCTIONS from INSIDE the "Library.bat."

(%(:?=Library% && (call :revision)||(%failedLibrary%))2>nul
    call :stdlib /w:50 /h:50 /fs:8 /title:"My Title" /extlib /rgb:"r;g;b":"r;g;b" /3rdparty /debug
    call :cursor
    call :math
    call :misc
    call :shapes
    call :algorithicConditions
    call :turtleFunctions
    call :quikzip
    call :colorRange
    call :loadArray
    call :macros
%)%  && (cls&goto :setup)

:setup

pause & exit

rem CALL :STDLIB <ARGUEMENTS CAN BE IN ANY ORDER YOU WANT>
rem 
rem /w        -  set width  of console, returns %wid%, %width%
rem /h        -  set height of console, returns %hei%, %height%
rem /fs       - font size (5-100). The default font style used is TERMINAL
rem /title    - speaks for itself, but make sure its surrounded in quotes ""
rem /extlib   - provides the backspace(BS), BEL, CR, and TAB characters as variables
rem /rgb      - must surroud your color codes in quotes ""  Example: RED background/BLACK text:->    /rgb:"255;0;0":"0;0;0" 
rem /3rdparty - IF %temp%/batch does not exist on current machine,
rem     puts the following tools insides the folder
rem         
rem         a. curl.exe
rem         b. nircmd.exe
rem         c. wget.exe
rem         d. inject.exe ( tool used to inject getinput.dll into cmd )
rem         e. getinput.dll ( non-blocking input tool for mouse postion, clicks, and keypresses )
rem         f. mouse.exe
rem 
rem     /3rdparty also provides the current variables as macros for however you want to use them
rem         
rem             USE AS COMMANDS
rem
rem         a. %curl% <CURL SYNTAX>        SEE: https://ss64.com/nt/curl.html
rem         b. %nircmd% <NIRCMD SYNTAX>    SEE: https://nircmd.nirsoft.net/
rem         c. %wget% <WGET SYNTAX>        SEE: https://www.gnu.org/software/wget/manual/wget.html
rem         d. %import_getInput.dll% - the moment this is called, you can use
rem             d.1. mouseXpos
rem             d.2. mouseYpos
rem             d.3. keypressed
rem             d.4. click <rtns 1-2 or nothing>
rem         e. %getMouseXY% - use mouse.exe to capture the following
rem             e.1. mouseX
rem             e.2. mouseY
rem             e.3. mouseC
rem         f. %clearMouse% to set e.1-3. = 0
rem 
rem /debug - turns on debug mode, echo is ON, font is larger, font set to consolas
rem     for readability, and a larger console size to see all the code in one spot. 
rem     I find this argument useful when debugging new macros for the library.
rem
rem STDLIB provides the following variables for you to use.
rem 
rem %pixel% - Û character
rem %.%     - Û character
rem %esc%   - esc character
rem %\e%    - esc character
rem %cls%   - echo or <nul set /p "=" to clear screen
rem %\c%    - same as %cls%
rem %\rgb%  - sets the color code from %R% %G% %B% if defined.
rem %\n%     - new line
rem Hides cursor

rem CALL :CURSOR <no arguments>
rem 
rem Provides the following as macros.
rem 
rem %>%               - <nul set /p "=" but less to type.
rem
rem All of these here must be echo'd or %>%
rem %push%            - save current x y postion
rem %pop%             - return to saved x y postion
rem %cursor[U]:?=NUM% - change NUM to amount you want cursor to move UP
rem %cursor[D]:?=NUM% - change NUM to amount you want cursor to move DOWN
rem %cursor[L]:?=NUM% - change NUM to amount you want cursor to move LEFT
rem %cursor[R]:?=NUM% - change NUM to amount you want cursor to move RIGHT
rem %cac%             - clear above cursor
rem %cbc%             - clear below cursor
rem %underline%       - use prior to echoing something you want underlined. EX: echo %underline%Hello World
rem %capit%           - stops colorizing, underlines, or all string attributes by vt100
rem %moveXY%          - sets cursor to postition x,y if defined.
rem %home%            - sets cursor to 0,0
rem 
rem %setDefaultColor% - no need to echo. Will set console color to initial set during library load.
rem %setStyle% - 1 arguement. RGB or BIT. RGB(2) will expect "r;g;b" as a color code where as BIT(5)
rem     will expect 0-255 as a color code.

rem CALL :MATH <no arguments>
rem 
rem Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%
rem
rem %PI%                -  31416
rem %HALF_PI%           -  15708
rem %TWO_PI%            -  62832
rem %PI32%              -  47124
rem %NEG_PI%            - -31416
rem %NEG_HALF_PI%       - -15708
rem %SIN%               - provide x as  theta/angle as 0-360
rem %COS%               - provide x as theta/angle as 0-360
rem %SINR%              - provide x as theta/angle as 0-TWO_PI
rem %COSR%              - provide x as theta/angle as 0-TWO_PI
rem %sqrt(N)%           - provide N
rem %sign%              - provide x
rem %abs%               - provide x
rem %dist(x2,x1,y2,y1)% - get distance from one point to another.
rem %avg%               - return average or x and y 
rem %map%               - v = value to change, a = v-FROM, b = v-TO, c = v-DESIRED-FROM, d = v-DESIRED-TO
rem                        EX: set /a "v=5", "a=0", "b=10", "c=100", "d=200", "output=%map%"
rem %lerp%              - provide a, b, c, refer to: https://en.wikipedia.org/wiki/Linear_interpolation
rem %swap%              - provided x and y are defined, swap them
rem %getState%          - provide a, b, c, d, returns 0-15

rem CALL :MISC <no arguments>
rem 
rem Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%
rem
rem %gravity%           - accerlation increases by 1 per frame,
rem                         velocity increases by accerlation per frame,
rem                         Y position is increased by velocity per frame
rem %percentOf%         - provide x, y as X percent of Y. EX set /a "x=76, y=83", "out=%percentOf%" %out% = 63. True answer is 63.08.
rem %chance%            - provide x. requires 2>nul redirection, but works as such.
rem                        EX: set /a "%chance:x=25%" && ( echo 25 percent chance ) || ( echo 75 percent chance )
rem %every%             - provide x  EX: set /a "%every:x=frameCount%" && ( code )
rem %smoothStep%        - provide x
rem %bitcolor%          - translate R G B to BITCOLOR
rem %loop%              - begin infinite loop
rem %throttle%          - provide x to THROTTLE the script. (this can make animations that are too fast look better)
rem %ifOdd%             - provide x  EX:  set /a "%ifOdd:x=3%" && ( code )
rem %ifEven%            - provide x  EX:  set /a "%ifEven:x=3%" && ( code )
rem %RCX%               - provide x returns 1 if 0 < x < wid  EX:  set /a "%RCX:x=-10%" || ( code )
rem %RCY%               - provide x returns 1 if 0 < x < hei  EX:  set /a "%RCY:x=-10%" || ( code )
rem %edgeCase%          - provide x, y returns 1 if 0 < x & y < wid & hei   EX:  set /a "%edgeCase%" && ( code )
rem %rndBetween%        - provide x  get a random number between -x and x
rem %fib%               - returns fibonacci sequence
rem %mouseBound%        - provide ma, mb, mc, md as edge cases to mouse clicks.

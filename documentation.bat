    this script is not intended to be ran.-----v


    Open the library by substituting '?' with the name of the library in the variable %(%
     and check if the required revision OR LESS is being used. If everything checks out,
    it will CALL :FUNCTIONS from INSIDE the "Library.bat."

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

    CALL :STDLIB <ARGUEMENTS CAN BE IN ANY ORDER YOU WANT>
    
    /w        -  set width  of console, returns %wid%, %width%
    /h        -  set height of console, returns %hei%, %height%
    /fs       - font size (5-100). The default font style used is TERMINAL
    /title    - speaks for itself, but make sure its surrounded in quotes ""
    /extlib   - provides the backspace(BS), BEL, CR, and TAB characters as variables
    /rgb      - must surroud your color codes in quotes ""
    /3rdparty - IF %temp%/batch does not exist on current machine,
        puts the following tools insides the folder
            
            a. curl.exe
            b. nircmd.exe
            c. wget.exe
            d. inject.exe ( tool used to inject getinput.dll into cmd )
            e. getinput.dll ( non-blocking input tool for mouse postion, clicks, and keypresses )
            f. mouse.exe
    
        /3rdparty also provides the current variables as macros for however you want to use them
            
                USE AS COMMANDS
rem
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
    
    /debug - turns on debug mode, echo is ON, font is larger, font set to consolas
        for readability, and a larger console size to see all the code in one spot. 
        I find this argument useful when debugging new macros for the library.
rem
    STDLIB provides the following variables for you to use.
    
    %pixel% - Û character
    %.%     - Û character
    %esc%   - esc character
    %\e%    - esc character
    %cls%   - echo or <nul set /p "=" to clear screen
    %\c%    - same as %cls%
    %\rgb%  - sets the color code from %R% %G% %B% if defined.
    %\n%     - new line
    Hides cursor

    CALL :CURSOR <no arguments>
    
    Provides the following as macros.
    
    %>%               - <nul set /p "=" but less to type.
rem
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

    CALL :MATH <no arguments>
    
    Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%
rem
    %PI%                -  31416
    %HALF_PI%           -  15708
    %TWO_PI%            -  62832
    %PI32%              -  47124
    %NEG_PI%            - -31416
    %NEG_HALF_PI%       - -15708
    %SIN%               - provide x as  theta/angle as 0-360
    %COS%               - provide x as theta/angle as 0-360
    %SINR%              - provide x as theta/angle as 0-TWO_PI
    %COSR%              - provide x as theta/angle as 0-TWO_PI
    %sqrt(N)%           - provide N
    %sign%              - provide x
    %abs%               - provide x
    %dist(x2,x1,y2,y1)% - get distance from one point to another.
    %avg%               - return average or x and y 
    %map%               - v = value to change, a = v-FROM, b = v-TO, c = v-DESIRED-FROM, d = v-DESIRED-TO
                           EX: set /a "v=5", "a=0", "b=10", "c=100", "d=200", "output=%map%"
    %lerp%              - provide a, b, c, refer to: https://en.wikipedia.org/wiki/Linear_interpolation
    %swap%              - provided x and y are defined, swap them
    %getState%          - provide a, b, c, d, returns 0-15

    CALL :MISC <no arguments>
    
    Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%
rem
    %gravity%           - accerlation increases by 1 per frame,
                            velocity increases by accerlation per frame,
                            Y position is increased by velocity per frame
    %percentOf%         - provide x, y as X percent of Y. EX set /a "x=76, y=83", "out=%percentOf%" %out% = 63. True answer is 63.08.
    %chance%            - provide x. requires 2>nul redirection, but works as such.
                           EX: set /a "%chance:x=25%" && ( echo 25 percent chance ) || ( echo 75 percent chance )
    %every%             - provide x  EX: set /a "%every:x=frameCount%" && ( code )
    %smoothStep%        - provide x
    %bitcolor%          - translate R G B to BITCOLOR
    %loop%              - begin infinite loop 
                            (NOT A MATH OPERATION) SEE LINE: :MISC/loop in Library.bat
    %throttle%          - provide x to THROTTLE the script. (this can make animations that are too fast look better)
                            (NOT A MATH OPERATION) SEE LINE: :MISC/throttle in Library.bat
    %ifOdd%             - provide x  EX:  set /a "%ifOdd:x=3%" && ( code )
    %ifEven%            - provide x  EX:  set /a "%ifEven:x=3%" && ( code )
    %RCX%               - provide x returns 1 if 0 < x < wid  EX:  set /a "%RCX:x=-10%" || ( code )
    %RCY%               - provide x returns 1 if 0 < x < hei  EX:  set /a "%RCY:x=-10%" || ( code )
    %edgeCase%          - provide x, y returns 1 if 0 < x & y < wid & hei   EX:  set /a "%edgeCase%" && ( code )
    %rndBetween%        - provide x  get a random number between -x and x
    %fib%               - returns fibonacci sequence
    %mouseBound%        - provide ma, mb, mc, md as edge cases to mouse clicks.

    CALL :SHAPES <no arguments>
    
    Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%
rem
    %SQ(x)%             - provide x         - returns x^2 or area of square.
    %CUBE(x)%           - provide x         - returns x^3 or area of cube
    %pmSQ(x)%           - provide x         - returns x * 4
    %pmREC(l,w)%        - provide l, w      - returns l * 2 + w * 2
    %pmTRI(a,b,c)%      - provide a, b, c   - returns a + b + C
    %areaREC(l,w)%      - provide l, w      - returns l * w
    %areaTRI(b,h)%      - provide b, h      - returns b * h / 2
    %areaTRA(b1,b2,h)%  - provide b1, b2, h - returns b1 * b2 * h / 2
    %volBOX(l,w,h)%     - provide l, w, h   - returns l * w * h

    CALL :algorithicConditions <no arguments>
    
    Provides the following variables to be used in set /a using substitution. EX: %SIN:x=90%
    
    %LSS(x,y)%             - provide x, y         - <
    %LEQ(x,y)%             - provide x, y         - <=
    %GTR(x,y)%             - provide x, y         - >
    %GEQ(x,y)              - provide x, y         - >=
    %EQU(x,y)%             - provide x, y         - ==
    %NEQ(x,y)%             - provide x, y         - !=
    %AND(b1,b2)%           - provide b1, b2       - &&
    %OR(b1,b2)%            - provide b1, b2       - ||
    %XOR(b1,b2)%           - provide b1, b2       - ^
    %TERN(bool,v1,v2)%     - provide bool, v1, v2 - ?:

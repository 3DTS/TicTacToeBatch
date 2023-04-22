REM ESC: CTRL + Ü (= QWERTZ-Layout) 
@echo off
setlocal enableDelayedExpansion
TITLE TicTacToe
set spaces=                         
set iteration=0

REM Set default player colors and names.
set player_color1=[91m
set player_color2=[94m
set p1=Player 1
set p2=Player 2

REM Field numbers for all possible winning combinations.
set win[0]=1 2 3
set win[1]=4 5 6
set win[2]=7 8 9
set win[3]=1 4 7
set win[4]=2 5 8
set win[5]=3 6 9
set win[6]=1 5 9
set win[7]=3 5 7

REM Title screen
:TITLE
cls
echo  _____   _   ___    _____     ___     ___    _____   _____   ___
echo ^|_   _^| ^| ^| ^|  _^|  ^|_   _^|   / _ \   ^|  _^|  ^|_   _^| ^|  _  ^| ^| __^|
echo   ^| ^|   ^| ^| ^| ^|_     ^| ^|    / /_\ \  ^| ^|_     ^| ^|   ^| ^|_^| ^| ^| _^|
echo   ^|_^|   ^|_^| ^|___^|    ^|_^|   /_/   \_\ ^|___^|    ^|_^|   ^|_____^| ^|___^|
echo.
echo.
echo %spaces% 1. Start
echo %spaces% 2. Settings
echo %spaces% 0. Exit
echo.
echo Type in the number of the option to go to:
set /p menu_select=

REM Jump to the corresponding menu point.
IF %menu_select% EQU 1 GOTO START
IF %menu_select% EQU 2 GOTO SETTINGS
IF %menu_select% EQU 0 GOTO EXIT
GOTO TITLE

REM Settings allows some modifications.
REM For now only Player's names and color can be changed.
:SETTINGS
REM Set variable to return to title as default option if input is empty.
set menu_select=0
cls
echo.
echo %spaces% 1. !player_color1!!p1![0m color
echo %spaces% 2. !player_color2!!p2![0m color
echo %spaces% 3. Set Player names
echo %spaces% 4. Set Computer opponent
echo %spaces% 0. Back

set /p menu_select=

IF %menu_select% EQU 1 GOTO SET_PLAYER_COLOR
IF %menu_select% EQU 2 GOTO SET_PLAYER_COLOR
IF %menu_select% EQU 3 GOTO SET_PLAYER_NAMES
IF %menu_select% EQU 4 GOTO SET_COMPUTER
IF %menu_select% EQU 0 GOTO TITLE 

REM Reload settings if input is not correct.
GOTO SETTINGS

:SET_PLAYER_COLOR
echo 0. [90mGray[0m
echo 1. [91mRed[0m
echo 2. [92mGreen[0m
echo 3. [93mYellow[0m
echo 4. [94mBlue[0m
echo 5. [95mMagenta[0m
echo 6. [96mCyan[0m
echo 7. [97mWhite[0m

set /p color_select=
set player_color%menu_select%=[9!color_select!m

GOTO SETTINGS

:SET_PLAYER_NAMES
REM Wait for players to put in a custom Name.
echo.%player_color1%%p1%[0m:
set /p "p1="

echo.%player_color2%%p2%[0m:
set /p "p2="

REM Set default name if no name was set.
if not defined p1 set "p1=Player 1"
if not defined p2 set "p2=Player 2"

GOTO SETTINGS

:SET_COMPUTER
REM Let User decide which player to set as the computer opponent. (0 = none, 1 = Player 1, 2 = Player 2)
REM choice also prevents from setting both players as computer.
choice /c 012 /m "Which player should be the computer opponent? (0 = none) "

REM The index of the key from choice is set in the environment variable "errorlevel".
set /a computer_no=%errorlevel%-1
REM Print text depending on the choice.
IF !computer_no! NEQ 0 (echo Player !computer_no! is now the computer opponent!) else (echo No player has been selected!)
pause > nul

GOTO SETTINGS

REM Game start.
:START
REM Set the displayed name and color.
set player1=%player_color1%%p1%[0m
set player2=%player_color2%%p2%[0m

REM Failsave: Set variable to 0 if not defined.
IF not defined computer_no set computer_no=0

REM Set computer to assigned player.
IF !computer_no! EQU 1 set computer=!player1!
IF !computer_no! EQU 2 set computer=!player2!


set current_player=%player1%

REM "field" contains the symbol of the corresponding player (number 1-9 = empty).
REM Set the color of the cells content to gray.
set field[1].color=[90m
set field[2].color=[90m
set field[3].color=[90m
set field[4].color=[90m
set field[5].color=[90m
set field[6].color=[90m
set field[7].color=[90m
set field[8].color=[90m
set field[9].color=[90m

REM Set numbers for the blank cells.
set field[1].content=1
set field[2].content=2
set field[3].content=3
set field[4].content=4
set field[5].content=5
set field[6].content=6
set field[7].content=7
set field[8].content=8
set field[9].content=9

REM Set numbers for magic square calculation.
REM 'X' excludes empty cells from calculation.
REM If cell cntains a symbol, the letter will be replaced by a sign.
set field[1].square=X4
set field[2].square=X3
set field[3].square=X8
set field[4].square=X9
set field[5].square=X5
set field[6].square=X1
set field[7].square=X2
set field[8].square=X7
set field[9].square=X6

REM Reset victory and turn variables.
REM "victory" is used to indicate if a player has won.
REM "turn" counts the number of turns (max. 9).
set victory=0
set turn=0

REM Clear variable.
REM Otherwise that field could be set in the next game.
set input=

REM Prints game grid with all placed symbols.
REM Symbols will be in player's color.
:PRINT_FIELD
cls

REM Set upper, middle and lower rows of fields with content.
set "up= !field[7].color!!field[7].content![0m | !field[8].color!!field[8].content![0m | !field[9].color!!field[9].content![0m"
set "mid= !field[4].color!!field[4].content![0m | !field[5].color!!field[5].content![0m | !field[6].color!!field[6].content![0m"
set "low= !field[1].color!!field[1].content![0m | !field[2].color!!field[2].content![0m | !field[3].color!!field[3].content![0m"

REM Print grid.
echo.!up!
echo.---+---+---
echo.!mid!
echo.---+---+---
echo.!low!

REM Check if end conditions are true and exit game.
IF !victory! NEQ 0 (
	echo.!victory! wins^^!
	GOTO GAME_END
)
IF !turn! EQU 9 (
	echo.Draw^^!
	GOTO GAME_END
)

IF !current_player! EQU !computer! GOTO COMPUTER

REM Read input.
:GET_INPUT
set /p "input=!current_player!: "
IF !input! EQU 0 GOTO TITLE
IF "!input!" EQU "" (
	echo.[41m Invalid input^^! [0m
	GOTO GET_INPUT
)

REM Check if input is correct.
:CHECK_INPUT
REM Go back to title.
IF !input! EQU 0 GOTO TITLE

REM x is used to select the array position.
REM set /a x=!input!-1

REM If "input" is equal to the content on that array position (= field), 
REM the field is empty and can be filled with a symbol.
IF /I !!field[%input%].content!! EQU !input! (

	REM Check which player is active to place the correct symbol and color.
	IF !current_player! EQU !player1! (
		set current_player=!player2!
		set field[!input!].color=!player_color1!
		set field[!input!].content=X
		
		REM Extract the last caracter of that string (which is a number)
		REM to enable "magic square" calculation for that field.
		set field[!input!].square=!field[%input%].square:~-1!
	) else (
		set current_player=!player1!
		set field[!input!].color=!player_color2!
		set field[!input!].content=O
		set field[!input!].square=-!field[%input%].square:~-1!
	)
) else (
	echo.[41m Invalid input^^! [0m
	GOTO GET_INPUT
)

REM Increase turn by 1.
set /a turn=!turn!+1

REM Earliest victory can be at 5th turn.
IF !turn! GEQ 5 (
	FOR /L %%i IN (0 1 7) DO (
		CALL :CHECK_VICTORY !!win[%%i]!!
		REM Exit if victory was found.
		if !errorlevel! NEQ 0 (
			IF !errorlevel! EQU 1 set victory=!player1!
			IF !errorlevel! EQU 2 set victory=!player2!
			GOTO PRINT_FIELD
		)
	)
) 
GOTO PRINT_FIELD

:COMPUTER
set computer_move=-2

echo Thinking...

FOR /L %%i IN (1 1 9) DO (
	echo CELL %%i
	IF /I !!field[%%i].content!! EQU %%i (
		IF !computer_no! EQU 1 (
			set field[%%i].content=X
			set field[%%i].square=!field[%%i].square:~-1!
			CALL :MINIMAX !turn! 2
		)
		IF !computer_no! EQU 2 (
			set field[%%i].content=O
			set field[%%i].square=-!field[%%i].square:~-1!
			CALL :MINIMAX !turn! 1
		)
		set /a tmp_score=-!errorlevel!
		
		set field[%%i].content=%%i
		set field[%%i].square=X!field[%%i].square:~-1!
		
		IF !tmp_score! GTR !computer_move! (
			set computer_move=!tmp_score!
			set input=%%i
		)
	)
	
)
GOTO CHECK_INPUT

REM PARAMETERS:
REM depth player_no
:MINIMAX
set /a iteration=!iteration!+1
FOR /L %%i IN (0 1 7) DO (
	CALL :CHECK_VICTORY !!win[%%i]!! M
	IF !errorlevel! EQU !computer_no! EXIT /b 1
	IF !errorlevel! NEQ 0 EXIT /b -1
)

IF %1 GEQ 9 EXIT /b 0

IF %2 EQU !computer_no! (
	set best_score=-10
	FOR /L %%i IN (1 1 9) DO (
		IF /I !!field[%%i].content!! EQU %%i (
			set /a depth=%1+1
			IF !computer_no! EQU 1 (
				set field[%%i].content=X
				set field[%%i].square=!field[%%i].square:~-1!
				CALL :MINIMAX !depth! 2
			)
			IF !computer_no! EQU 2 (
				set field[%%i].content=O
				set field[%%i].square=-!field[%%i].square:~-1!
				CALL :MINIMAX !depth! 1
			)
			set /a score=-!errorlevel!
			
			IF !score! GTR !best_score! set best_score=!score!
			set field[%%i].content=%%i
			set field[%%i].square=X!field[%%i].square:~-1!
		)
	)
) ELSE (
	set best_score=10
	
	FOR /L %%i IN (1 1 9) DO (
		IF /I !!field[%%i].content!! EQU %%i (
			set /a depth=%1+1
			IF !computer_no! NEQ 1 (
				set field[%%i].content=X
				set field[%%i].square=!field[%%i].square:~-1!
				CALL :MINIMAX !depth! 2
			)
			IF !computer_no! NEQ 2 (
				set field[%%i].content=O
				set field[%%i].square=-!field[%%i].square:~-1!
				CALL :MINIMAX !depth! 1
			)
			set /a score=-!errorlevel!
			
			IF !score! LSS !best_score! set best_score=!score!
			set field[%%i].content=%%i
			set field[%%i].square=X!field[%%i].square:~-1!
		)
	)
)
echo DEPTH !depth!
echo ITERATION !iteration!

EXIT /b !best_score!


REM Check for each row, column and diagonal if the sum is equal to 15 for "Player 1" or -15 for "Player 2".
REM This function is called with 3 parameters containing field numbers to check for a victory.
REM Returns 0 if no victory was found, 1 if "Player 1" wins and 2 if "Player 2" wins.
:CHECK_VICTORY
set /a sum=!field[%1].square!+!field[%2].square!+!field[%3].square!
set v=0
set minimax=%4

REM Check if sum is equal to 15 or -15.
REM If that is the case, highlight the winning fields.
IF !sum! EQU 15 set v=1
IF !sum! EQU -15 set v=2

REM Skip highlighting if minimax-algorithm calls this function.
IF defined minimax (
	EXIT /b !v!
)

REM Invert field colors to highlight them.
IF !v! NEQ 0 (
	set field[%1].color=!field[%1].color![7m
	set field[%2].color=!field[%2].color![7m
	set field[%3].color=!field[%3].color![7m
)

EXIT /b !v!

:GAME_END
pause
GOTO TITLE

:EXIT
echo Goodbye^^!
pause
EXIT /b

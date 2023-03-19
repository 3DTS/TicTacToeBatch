@echo off
setlocal enableDelayedExpansion
TITLE TicTacToe
set spaces=                         

REM Set default player colors and names.
set player_color1=[91m
set player_color2=[94m
set p1=Player 1
set p2=Player 2

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
echo %spaces% 3. Exit
echo.
echo Type in the number of the option to go to:
set /p menu_select=

REM Jump to the corresponding menu point.
IF %menu_select% EQU 1 GOTO START
IF %menu_select% EQU 2 GOTO SETTINGS
IF %menu_select% EQU 3 GOTO EXIT
GOTO TITLE

:SETTINGS
cls
echo.
echo %spaces% 1. !player_color1!!p1![0m color
echo %spaces% 2. !player_color2!!p2![0m color
echo %spaces% 3. Set Player names
echo %spaces% 0. Back

set /p menu_select=

IF %menu_select% EQU 1 GOTO SET_PLAYER_COLOR
IF %menu_select% EQU 2 GOTO SET_PLAYER_COLOR
IF %menu_select% EQU 3 GOTO SET_PLAYER_NAMES
IF %menu_select% EQU 0 GOTO TITLE 

GOTO TITLE

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

REM Set default name if no custom name was set.
if "%p1%" EQU "" set "p1=Player 1"
if "%p2%" EQU "" set "p2=Player 2"

GOTO SETTINGS

:START
REM Set the displayed name and color.
set player1=%player_color1%%p1%[0m
set player2=%player_color2%%p2%[0m

set current_player=%player1%

REM field contains the symbol of the corresponding player (number 1-9 = empty).
REM Set the color of the cells content to grey.
set field[0].color=[90m
set field[1].color=[90m
set field[2].color=[90m
set field[3].color=[90m
set field[4].color=[90m
set field[5].color=[90m
set field[6].color=[90m
set field[7].color=[90m
set field[8].color=[90m

REM Set numbers for the blank cells.
set field[0].content=1
set field[1].content=2
set field[2].content=3
set field[3].content=4
set field[4].content=5
set field[5].content=6
set field[6].content=7
set field[7].content=8
set field[8].content=9

REM Set numbers for magic square calculation.
REM 'X' excludes cells from calculation (= cells are empty).
set field[0].square=X4
set field[1].square=X3
set field[2].square=X8
set field[3].square=X9
set field[4].square=X5
set field[5].square=X1
set field[6].square=X2
set field[7].square=X7
set field[8].square=X6

set victory=0
set round=0

REM Clear variable.
REM Otherwise that field could be set in the next game.
set input=

REM Prints field with all placed symbols.
REM Symbols will be in player colors.
:PRINT_FIELD
cls
set "up= !field[6].color!!field[6].content![0m | !field[7].color!!field[7].content![0m | !field[8].color!!field[8].content![0m"
set "mid= !field[3].color!!field[3].content![0m | !field[4].color!!field[4].content![0m | !field[5].color!!field[5].content![0m"
set "low= !field[0].color!!field[0].content![0m | !field[1].color!!field[1].content![0m | !field[2].color!!field[2].content![0m"

echo.!up!
echo.---+---+---
echo.!mid!
echo.---+---+---
echo.!low!

REM Check if end conditions are true.
IF !victory! NEQ 0 (
	echo.!current_player! wins^^!
	GOTO GAME_END
)
IF !round! EQU 9 (
	echo.Draw^^!
	GOTO GAME_END
)

REM Read input.
:GET_INPUT
set /p "input=!current_player!: "
IF "!input!" EQU "" (
	echo.[41m Invalid input^^! [0m
	GOTO GET_INPUT
)

REM Check if input is correct.
:CHECK_INPUT
REM x is used to select the array position.
set /a x=!input!-1

REM If "input" is equal to the content on that array position (=cell), 
REM the cell is empty and can be filled with a symbol.
IF /I "!!field[%x%].content!!" EQU "!input!" (

	REM Check which player is active to place the correct symbol and color.
	IF !current_player! EQU !player1! (
		set current_player=!player2!
		set field[!x!].color=!player_color1!
		set field[!x!].content=X
		
		REM Extract the last caracter of that string (which must be a number)
		REM for the "magic square" calculation.
		set field[!x!].square=!field[%x%].square:~-1!
	) else (
		set current_player=!player1!
		set field[!x!].color=!player_color2!
		set field[!x!].content=O
		set field[!x!].square=-!field[%x%].square:~-1!
	)
) else (
	echo.[41m Invalid input^^! [0m
	GOTO GET_INPUT
)

set /a round=!round!+1

REM Earliest victory can be at 5. turn.
IF !round! LSS 5 (GOTO PRINT_FIELD) ELSE (GOTO CHECK_VICTORY)

REM Check for each row, column and diagonal if the sum is equal to 15 for "Player1" or -15 for "Player2".
REM VICTORY_CHECK_PTR points to the next set of fields to be checked.
REM VICTORY_PTR is used to jump back to highlight the winning set of fields.
REM The jumpmarkers ":_XX_VICTORY" are used to add a color inversion (highlight) to the winning fields.
:CHECK_VICTORY
REM (horizontal)
set /a sum=!field[0].square!+!field[1].square!+!field[2].square!
set VICTORY_CHECK_PTR=_H1
set VICTORY_PTR=_H0_VICTORY
GOTO CHECK_SUM
:_H0_VICTORY
set field[0].color=!field[0].color![7m
set field[1].color=!field[1].color![7m
set field[2].color=!field[2].color![7m
GOTO PRINT_FIELD

:_H1
set /a sum=!field[3].square!+!field[4].square!+!field[5].square!
set VICTORY_CHECK_PTR=_H2
set VICTORY_PTR=_H1_VICTORY
GOTO CHECK_SUM
:_H1_VICTORY
set field[3].color=!field[3].color![7m
set field[4].color=!field[4].color![7m
set field[5].color=!field[5].color![7m
GOTO PRINT_FIELD

:_H2
set /a sum=!field[6].square!+!field[7].square!+!field[8].square!
set VICTORY_CHECK_PTR=_V0
set VICTORY_PTR=_H2_VICTORY
GOTO CHECK_SUM
:_H2_VICTORY
set field[6].color=!field[6].color![7m
set field[7].color=!field[7].color![7m
set field[8].color=!field[8].color![7m
GOTO PRINT_FIELD

REM (vertical)
:_V0
set /a sum=!field[0].square!+!field[3].square!+!field[6].square!
set VICTORY_CHECK_PTR=_V1
set VICTORY_PTR=_V0_VICTORY
GOTO CHECK_SUM
:_V0_VICTORY
set field[0].color=!field[0].color![7m
set field[3].color=!field[3].color![7m
set field[6].color=!field[6].color![7m
GOTO PRINT_FIELD

:_V1
set /a sum=!field[1].square!+!field[4].square!+!field[7].square!
set VICTORY_CHECK_PTR=_V2
set VICTORY_PTR=_V1_VICTORY
GOTO CHECK_SUM
:_V1_VICTORY
set field[1].color=!field[1].color![7m
set field[4].color=!field[4].color![7m
set field[7].color=!field[7].color![7m
GOTO PRINT_FIELD

:_V2
set /a sum=!field[2].square!+!field[5].square!+!field[8].square!
set VICTORY_CHECK_PTR=_D0
set VICTORY_PTR=_V2_VICTORY
GOTO CHECK_SUM
:_V2_VICTORY
set field[2].color=!field[2].color![7m
set field[5].color=!field[5].color![7m
set field[8].color=!field[8].color![7m
GOTO PRINT_FIELD

REM (diagonal)
:_D0
set /a sum=!field[0].square!+!field[4].square!+!field[8].square!
set VICTORY_CHECK_PTR=_D1
set VICTORY_PTR=_D0_VICTORY
GOTO CHECK_SUM
:_D0_VICTORY
set field[0].color=!field[0].color![7m
set field[4].color=!field[4].color![7m
set field[8].color=!field[8].color![7m
GOTO PRINT_FIELD

:_D1
set /a sum=!field[2].square!+!field[4].square!+!field[6].square!
set VICTORY_CHECK_PTR=PRINT_FIELD
set VICTORY_PTR=_D1_VICTORY
GOTO CHECK_SUM
:_D1_VICTORY
set field[2].color=!field[2].color![7m
set field[4].color=!field[4].color![7m
set field[6].color=!field[6].color![7m
GOTO PRINT_FIELD

REM Check if sum is equal to 15 or -15.
REM If that is the case, jump back to highlight the winning fields.
:CHECK_SUM
IF !sum! EQU 15 (
	set current_player=!player1!
	set victory=1
	GOTO !VICTORY_PTR!
)
IF !sum! EQU -15 (
	set current_player=!player2!
	set victory=1
	GOTO !VICTORY_PTR!
)
GOTO !VICTORY_CHECK_PTR!

:GAME_END
pause
GOTO TITLE

:EXIT
echo Goodbye^^!
pause

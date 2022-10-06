@echo off
cls
setlocal enableDelayedExpansion
:START
:SET_PLAYER
REM Set player color.
set player_color1=[91m
set player_color2=[94m

REM Wait for players to put in a custom Name.
echo.%player_color1%Player 1[0m:
set /p "p1="

echo.%player_color2%Player 2[0m:
set /p "p2="

REM Set default name if no custom name was set.
if "%p1%" == "" set "p1=Player 1"
if "%p2%" == "" set "p2=Player 2"

REM Set the displayed name.
set player1=%player_color1%%p1%[0m
set player2=%player_color2%%p2%[0m

set current_player=%player1%
:_END_SET_PLAYER

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
REM 'X' excludes empty cells from calculation.
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

REM Prints field with corresponding player colors.
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
IF NOT !victory! == 0 GOTO VICTORY_MESSAGE
IF !round! == 9 (
	echo Draw!
	GOTO _END_VICTORY
)
:_END_PRINT_FIELD

REM Read input.
:GET_INPUT
set /p "input=!current_player!: "
:_END_GET_INPUT

REM Check if input is correct.
:CHECK_INPUT
REM x is used to select the array position.
set /a x=!input!-1

REM If "input" is equal to the content on that array position (=cell), 
REM the cell is empty and can be filled with a symbol.
IF /I "!!field[%x%].content!!" == "!input!" (

REM Check which player is active to place the correct symbol and color.
	IF !current_player! == !player1! (
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
	echo.[41m Invalid input! [0m
	GOTO GET_INPUT
)
set /a round=!round!+1
GOTO CHECK_VICTORY
:_END_CHECK_INPUT

REM Check for each row, column and diagonal if the sum is equal to 15 for "Player1" or -15 for "Player2".
:CHECK_VICTORY
REM (horizontal)
set /a sum=!field[0].square!+!field[1].square!+!field[2].square!
set VICTORY_CHECK_PTR=_H1
GOTO CHECK_SUM

:_H1
set /a sum=!field[3].square!+!field[3].square!+!field[5].square!
set VICTORY_CHECK_PTR=_H2
GOTO CHECK_SUM

:_H2
set /a sum=!field[6].square!+!field[7].square!+!field[8].square!
set VICTORY_CHECK_PTR=_V0
GOTO CHECK_SUM

REM (vertical)
:_V0
set /a sum=!field[0].square!+!field[3].square!+!field[6].square!
set VICTORY_CHECK_PTR=_V1
GOTO CHECK_SUM

:_V1
set /a sum=!field[1].square!+!field[4].square!+!field[7].square!
set VICTORY_CHECK_PTR=_V2
GOTO CHECK_SUM

:_V2
set /a sum=!field[2].square!+!field[5].square!+!field[8].square!
set VICTORY_CHECK_PTR=_D0
GOTO CHECK_SUM

REM (diagonal)
:_D0
set /a sum=!field[0].square!+!field[4].square!+!field[8].square!
set VICTORY_CHECK_PTR=_D1
GOTO CHECK_SUM

:_D1
set /a sum=!field[2].square!+!field[4].square!+!field[6].square!
set VICTORY_CHECK_PTR=PRINT_FIELD
GOTO CHECK_SUM

GOTO PRINT_FIELD
:_END_CHECK_VICTORY

:CHECK_SUM
IF !sum! == 15 (
	set current_player=!player1!
	set victory=1
	GOTO PRINT_FIELD
)
IF !sum! == -15 (
	set current_player=!player2!
	set victory=1
	GOTO PRINT_FIELD
)
GOTO !VICTORY_CHECK_PTR!

:VICTORY_MESSAGE
IF !victory! == 1 echo.!current_player! wins!
:_END_VICTORY

pause

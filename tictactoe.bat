@echo off
cls
setlocal enableDelayedExpansion
:START
:SET_PLAYER
set player_color1=[91m
set player_color2=[94m

echo.%player_color1%Player 1[0m:
set /p "p1="

echo.%player_color2%Player 2[0m:
set /p "p2="

if "%p1%" == "" set "p1=Player 1"
if "%p2%" == "" set "p2=Player 2"

set player1=%player_color1%%p1%[0m
set player2=%player_color2%%p2%[0m

set current_player=%player1%
:_END_SET_PLAYER

REM Field contains the symbol of the corresponding field (0 = empty).
set field=000000000
set one=[90m1
set two=[90m2
set three=[90m3
set four=[90m4
set five=[90m5
set six=[90m6
set seven=[90m7
set eight=[90m8
set nine=[90m9


:PRINT_FIELD
cls
set "up= !seven![0m | !eight![0m | !nine![0m"
set "mid= !four![0m | !five![0m | !six![0m"
set "low= !one![0m | !two![0m | !three![0m"

echo.!up!
echo.---+---+---
echo.!mid!
echo.---+---+---
echo.!low!
:_END_PRINT_FIELD

:GET_INPUT
IF "%current_player%" == "%player1%" (
	set /p "input=%player1%: "
) else (
	set /p "input=%player2%: "
)

REM Set the upper and lower limit to calculate the length of the upper and lower substring.
REM			low_end			up_end
REM			   |			  |
REM field = 000			0	   00000
REM 	   /   \		|	  /     \
REM	   low_substring	x	up_substring

set /a low_end=!input!-1
set /a up_end=!input!-9

REM Extract lower Substring until "input".
call set low_substring=%%field:~0,!low_end!%%
echo.!low_substring!

REM Extract upper Substring from "input".
call set up_subtring=%%field:~!input!%%
echo.!up_subtring!

REM Extract character on the position specified by "input".
call set x=%%field:~!low_end!,1%%
echo.%x%

REM Check if Symbol was already selected.
IF "!x!" == "0" (
	IF "!current_player!" == "!player1!" (
		set symbol=%player_color1%X
		set current_player=!player2!
		set field=!low_substring!X!up_subtring!
	) else (
		set symbol=%player_color2%O
		set current_player=!player1!
		set field=!low_substring!O!up_subtring!
	)
	echo true
	pause
	GOTO SET_SYMBOL
) else (
REM CHECK IF FIELD IS FULL --> GAME END ----------------------------------------------------------------------------------------------------------------------------------
	IF not x%field:0=%==x%field% (
		echo It contains 0
	) else (
			GOTO eof
		)
	echo.[41m Field already taken! [0m
	echo.x=%x%
	echo.x=!x!
	pause
	GOTO GET_INPUT
)
:_END_GET_INPUT

:CHECK_FIELD
:_END_CHECK_FIELD

:SET_SYMBOL

IF "!input!" == "1" (
	set one=!symbol!
) else (
	IF "!input!" == "2" (
		set two=!symbol!
	) else (
		IF "!input!" == "3" (
			set three=!symbol!
		) else (
			IF "!input!" == "4" (
				set four=!symbol!
			) else (
				IF "!input!" == "5" (
					set five=!symbol!
				) else (
					IF "!input!" == "6" (
						set six=!symbol!
					) else (
						IF "!input!" == "7" (
							set seven=!symbol!
						) else (
							IF "!input!" == "8" (
								set eight=!symbol!
							) else (
								IF "!input!" == "9" (
									set nine=!symbol!
								) else (
									echo ERROR
								)
							)
						)
					)
				)
			)
		)
	)
)

echo.End of selection
pause
GOTO PRINT_FIELD
:_END_SET_SYMBOL

:INVALID_INPUT
:_END_INVALID_INPUT

pause

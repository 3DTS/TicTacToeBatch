@echo off
cls
setlocal enableDelayedExpansion
:START
:SET_PLAYER
echo.[91mPlayer 1[0m:
set /p "p1="

echo.[94mPlayer 2[0m:
set /p "p2="

if "%p1%" == "" set "p1=Player 1"
if "%p2%" == "" set "p2=Player 2"

set player1=[91m%p1%[0m
set player2=[94m%p2%[0m

set current_player=%player1%
:_END_SET_PLAYER

rem echo !player1!
rem echo !player2!

REM In field evtl. das tatsächliche Zeichen reinschreiben (Statt 0 oder 1)
set field=000000000
set one=1
set two=2
set three=3
set four=4
set five=5
set six=6
set seven=7
set eight=8
set nine=9

cls

set "up= [90m!seven![0m | [90m!eight![0m | [90m!nine![0m"
set "mid= [90m!four![0m | [90m!five![0m | [90m!six![0m"
set "low= [90m!one![0m | [90m!two![0m | [90m!three![0m"

:PRINT_FIELD
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
REM echo INPUT=!input!

REM Set the upper and lower limit for the stringmanipulation to extract the currently selected symbol
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
IF "!x!"=="0" (
	echo true
	pause
	GOTO SET_SYMBOL
) else (
	echo.[41m Field already taken! [0m
	echo.x=%x%
	echo.x=!x!
	pause
	GOTO GET_INPUT
)
:_END_GET_INPUT

:SET_SYMBOL
IF "!current_player!" == "!player1!" (
	set symbol=X
	set current_player=!player2!
) else (
	set symbol=O
	set current_player=!player1!
)

IF "!input!" == "1" (
	set one=%symbol%
	echo.!one!
	echo.%one%
) else (
	IF "!input!" == "2" (
		set two=%symbol%
	) else (
		IF "!input!"=="3" (
			set three=%symbol%
		) else (
			IF "!input!"=="4" (
				set four=%symbol%
			) else (
				IF "!input!"=="5" (
					set five=%symbol%
				) else (
					IF "!input!"=="6" (
						set six=%symbol%
					) else (
						IF "!input!"=="7" (
							set seven=%symbol%
						) else (
							IF "!input!"=="8" (
								set eight=%symbol%
							) else (
								IF "!input!"=="9" (
									set nine=%symbol%
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

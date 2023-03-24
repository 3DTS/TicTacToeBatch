# TicTacToe in Batch
Tic-Tac-Toe on a Windows Terminal using a Batch-Script.

## Start and Navigation
Execute the .bat-file and navigate the menu by typing in the number of the option you want to go to and press Enter.

The game works in the same way. Just type in the number of the field you want to place your symbol in and confirm by pressing Enter.

## How the game works
The 3x3 grid is represented in the structure `field`. Each of the 9 fields has three characteristics:
- `color` stores the color of the content
- `content` contains the symbol (X or O) or the field number (if empty). 
- `square` contains the values for the "magic square" calculation. By default (= empty) fields have an additional letter, which the calculation ignores.

On the 5. turn the system checks after each turn if one of the players won by summing up each field of each row, column and diagonal. 
An additional letter in `square` ensures that the calculation ignores empty fields (In Batch the parameter `/a` will calculate numbers only).
If a symbol is placed by a player the letter will be removed or rather replaced by a sign, so only a positive or negative number is in that place. 
For "Player 1" the sign is positive, so the sum in case of a victory is (a positive) 15, and for "Player 2" the sign is negative, so the sum is -15. 
If a player has won the winning row is highlighted by inverting the fore- and background and it goes back to the main menu.

The victory check `:CHECK_VICTORY` is called with 3 parameters that contain the number of the fields that need to be checked. Those numbers are defined in the array `win[]`.
If a victory was was found `:CHECK_VICTORY` returns 1 or 2 according to "Player 1" or "Player 2", otherwise 0.


## Helpful links
##### How to use colors in batch:
- [Jean-Francois T.'s answer on Stackoverflow](https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line) 
- [Microsoft's Documentation](https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences)

##### Batch `call` and `exit`
- [`call` Documentation](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/call)
- [`exit` Documentation](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/exit)

##### Magic Square:
- [Wikipedia](https://en.wikipedia.org/wiki/Magic_square)

# Connect Four Game in PHP

### File intentions
* Info: This file will give information about the board but does not actually do anything functional
* New: This file will create a new game and a new file to save the state of the game
* Play: Allows the player to input a move, alters the board accordingly, and saves the altered board in a file
* Board: Contains board, and functions to interact with the board (game logic)
* commFunctions: Common functions: `makeError($msg)` and `addToTextDoc($pid, $jsonstring)`

### For Eric
**I finished writing it but I have not tested anything yet. Please test everything and fix any bugs you can find.**
Thanks,
Martin

### for Martin
**
yo i pretty much revamped your entire code. sorry. I changed i think all of your functions inside board class and unit tested each and every one of them to make sure they work, so they SHOULD work. What i havent tested is index.php which i also revamped. I added a function to make the movements of the players automatic, it might be a bit confusing but it should make sense. I did not test anything in index.php, please test and find bugs.
I changed the text file to only save and read an array,
I changed checkIfWin to only return true or false when receiving an array (a board)
I made a function getWinArray that returns an array of the coordinates as Cheon has it on his program
I made a simple function that checks if there is a tie. That being said I also dropped use of any other parameters inside your board object other than the actual board, sorry about that.
Give the code a good comparison with your code. Text me if any ideas/problems.

IMPORTANT! I also moved board.php and commFunctions.php into the play folder, because 1) its easier to just require files on same folder and 2) We shouldn't upload our php files to the Writable folder on CS Web server, its dangerous and I don't think its necessary. I believe I adjusted all of the 'require'(s) but I might have missed some on index.php. maybe, prob not

ps. I'm also sending the Testing folder I used for unit testing, it contains a function that prints the board quite nicely. Be careful with requiring the necessary files, for me it would not work, i spent like an hour trying to figure out why but I gave up and just copy pasted whatever functions i wanted to test.
**
Thanks
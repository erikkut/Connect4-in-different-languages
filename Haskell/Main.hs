-- Eric Torres 800# 80526035    Programming Languages Haskell Lab
module Main where 

import System.IO
import System.Random
import Board

-- #1 ------------------------------------------------------------------------------------------------------------------------------------------
-- Game implemented using a recursion loop that carries the modified board. 
-- More comments written around the code.

main = do 
	-- Initializing the variables in order to call the recursive functions within the 'where' clause.
	putStrLn "Welcome to connect 4\nEnter 1 for multi-player mode (vs. human), or any other integer for single-player mode (vs. random AI)\n"
	let brd = mkBoard 7 6
	strategy <- pickStrategy
	let strat = defineStrat strategy
	let brdString = boardToStr playerToChar brd
	putStrLn brdString
	let currentPlayer = opposingPlayer mkOpponent strat

	brd <- makeMove brd currentPlayer
	winningBoard <- gameLoop brd currentPlayer strat
	let winString = getWinString winningBoard
	putStrLn winString

	-- makeMove uses read slot and dropInSlot to update the board. It also returns and prints out the updated board.
	-- opposingPlayer is used to determine virtualize turn changing and to determine if you are playing vs human or vs computer.
	-- defineStrat is a helped method to convert IO Int into normal Int
	-- getWinString returns the winner of the board as a string for output. If no winner, it prints that nobody won.
	-- pickStrategy is a recursive loop that runs only once at the beginning in order to set the game-mode
	-- gameLoop is what plays the actual game. It calls itself recursively until a board with a winner is reached.
	where makeMove brd p = do 
		chosenSlot <- readSlot brd p
		let brd2 = dropInSlot brd chosenSlot p
		let brd = brd2
		let brdString = boardToStr playerToChar brd
		putStrLn brdString
		return brd
	      opposingPlayer curr strat 
		| curr == 1 && strat == 1 = 2
		| curr == 1 && strat == 0 = 3
		| otherwise = 1
	      defineStrat strat
		| strat == 1 = 1
		| otherwise = 0
	      getWinString winBoard
		| isWonBy winBoard 1 = "X won!"
		| isWonBy winBoard 2 = "O won!"
		| otherwise = "Nobody Won!"
	      pickStrategy = do
		line <- getLine
		let ans = reads line :: [(Int, String)] in
			if length ans == 0
			then pickStrategy'
			else do
				let (x, _) = head ans 
				if x > 0
				then return x
				else pickStrategy'
		where pickStrategy' = do
		      putStrLn "Invalid, re-enter"
		      pickStrategy
	      gameLoop brd p strat= do
		if isWonBy brd p
		then return brd
		else do
			let currentPlayer = opposingPlayer p strat
			updatedBoard <- makeMove brd currentPlayer
			winner <- gameLoop updatedBoard currentPlayer strat
			return winner
		where getWinner player = do
		      let winner = player
		      return winner

-- #2 ------------------------------------------------------------------------------------------------------------------------------------------
-- readSlot was implemented from the code provided Dr. Cheon's instructions. It had a minor bug, but it works by recursively calling itself
-- until a correct slot is chosen, whether it be picked by the user or randomly selected by the AI.

readSlot :: [Int] -> Int -> IO(Int)
readSlot (f:bd) p  
	| p < 3 = getSlot
	| otherwise = getRandom
	where getSlot = do
		putStrLn "Enter a positive column 1-7"
		line <- getLine
		let ans = reads line :: [(Int, String)] in
			if length ans == 0
			then getSlot'
			else do
				let (x, _) = head ans 
				if x > 0 && x <= f && isSlotOpen (f:bd) (x-1)
				then return (x-1)
				else getSlot'
		where getSlot' = do
			putStrLn "Invalid, re-enter"
			getSlot
	      getRandom = do
		putStrLn "Making AI move (Random)"
		x <- randomRIO(0, (f-1))
		let r = x in
			if isSlotOpen (f:bd) r
			then return r
			else getRandom'
		where getRandom' = do
			putStrLn "Strategy found a lane full, recalculating random slot"
			getRandom
		

-- Helper method to convert numbers in board to their corresponding symbols.

playerToChar :: Int -> Char
playerToChar x 
	| x == 1 = 'X'
	| x > 1 = 'O'  -- WAS ==
	| otherwise = '.'

-- #3 ------------------------------------------------------------------------------------------------------------------------------------------
-- Extra credit was integrated into lab. Random strategy was implemented, -1 exit was not.
-- Eric Torres 800# 80526035    Programming Languages Haskell Lab
module Board where

-- #1 -------------------------------------------------------------------------------------------------------------------------
-- The board is made using the replicate function, in order to initialize it to all zeros, 
-- the # of columns is saved in the head. (Useful since its used for majority of functions)

mkBoard :: Int -> Int -> [Int]
mkBoard x y = x:replicate (x*y) 0

mkPlayer :: Int
mkPlayer = 1

mkOpponent :: Int
mkOpponent = 2

-- #2 -------------------------------------------------------------------------------------------------------------------------
-- This function works by reversing the list of Ints representing the board, and checking from the bottom up. If a column spot is 
-- taken, then it goes up a row, (its reversed to it can actually go to next corresponding row) and recursively does this until 
-- it finds a spot. 

dropInSlot :: [Int] -> Int -> Int -> [Int]
dropInSlot (f:bd) i p
	| (r !! ri) == 0 = reverse (insert ri r) 
	| otherwise = dropInSlot (f:bd) (i-f) p 
	where   ri = (i - (f-1)) * -1
		r = reverse (f:bd)
		insert z tempBoard = h ++ p : t 
			where (h,_:t) = splitAt z tempBoard

isSlotOpen bd i = (tail bd !! i) == 0

numSlot bd = head bd

isFull (f:bd) = counter f bd where
	counter 0 _ = True
	counter k (h:t) 
		| h < 1 = False
		| otherwise = counter (k-1) bd

-- #3 -------------------------------------------------------------------------------------------------------------------------
-- Uses semi-static constants to determine winner. Each check recursively checks each head of the next tail for horizontal, 
-- vertical, and diagonal lines by index manipulation.

isWonBy (f:bd) p = horizontal bd || vertical bd || diagDown bd || diagUp (reverse bd)
	where   horizontal (h:t)
			| length t < 3 = False
			| h == p && t !! 0 == p && t !! 1 == p && t !! 2 == p && length t `mod` f > 2  && length t `mod` f < 7 = True
			| otherwise = horizontal t  
		vertical (h:t)
			| length t < (f*3) = False
			| h == p && t !! (f-1) == p && t !! (f*2-1) == p && t !! (f*3-1) == p = True
			| otherwise = vertical t
		diagDown (h:t)
			| length t < (f*3+(f`div`2)) = False
			| h == p && t !! (f) == p && t !! (f*2+1) == p && t !! (f*3+2) == p && length t `mod` f > 2 = True
			| otherwise = diagDown t
		diagUp (h:t)
			| length t < (f*3+(f`div`2)) = False
			| h == p && t !! (f-2) == p && t !! (f*2-3) == p && t !! (f*3-4) == p && length t `mod` f < 5 = True
			| otherwise = diagUp t

-- #4 -------------------------------------------------------------------------------------------------------------------------
-- Recursively adds every head to result after converting it to its corresponding char symbol.

boardToStr playerToChar (f:bd) = counter f bd where
	counter _ [] = []
	counter 0 bd = '\n':counter f bd
	counter k (h:t) = playerToChar h :' ': counter (k-1) t


-- For debugging purposes please disregard -------------------------------------------------------------------------------------
{-
disp s = putStrLn s

board = mkBoard 7 6
board1 = dropInSlot board 0 mkPlayer
board2 = dropInSlot board1 0 mkPlayer
board3 = dropInSlot board2 0 mkPlayer
board4 = dropInSlot board3 0 mkPlayer
boardT :: [Int]
boardT = [7,0,0,0,0,0,0,0,
	    0,0,0,0,0,0,0,
	    1,0,0,0,0,0,1,
	    0,0,1,0,0,0,1,
	    2,1,0,0,0,0,1,
	    1,2,0,1,1,0,1]
stringT = boardToStr playerToChar boardT
string = boardToStr playerToChar board4
-}


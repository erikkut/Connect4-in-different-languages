<?php
	/* Creates a board with 6 rows and 7 cols & initializes the board to all 0s 
	 * returns new board
	 * */
	function createBoard($strategy){
		$board = new Board();
		$board->boardArr = array_fill(0, $board->rows, array_fill(0, $board->cols, 0));
		$board->strategy = $strategy;
		return $board;
	}
	
	function loadBoard($arr, $count, $strategy) {
		$board = new Board();
		$board->boardArr = $arr;
		$board->count = $count;
		$board->strategy = $strategy;
		return $board;
	}
	
	function makeMove($board, $col, $tokenType){//COLUMN MUST BE INDEXED TO 0
		//no need to check if column full
		for($i = sizeof($board)-1; $i > 0; $i--){
			if($board[$i][$col] == 0){
				$board[$i][$col] = $tokenType;
				break;
			}
		}
		return $board;
	}
	
	function userMove($board, $col) {
		return makeMove($board, $col, 1);
	}
	
	function aiMove($board, $strat) {
		// find all available columns
		$arrOfPossMoves = array();
		$topRow = $board[0];
		foreach($topRow as $key=>$value){
			if($value == 0)
				array_push($arrOfPossMoves, $key);
		}
		if(sizeof($arrOfPossMoves) == 0) {
			return -1;
		}
	
		if($strat == "Smart") {
			// check if there is any move ai can do to win the game. If yes, return col
			foreach ($arrOfPossMoves as $col=>$value) {
				$tempBoard = makeMove($board, $col, 2);
				if(checkIfWin($tempBoard))
					return $col;
			}
	
			// check if there is any move a user can do to win the game, block that move. If yes, return column number to block it
			foreach ($arrOfPossMoves as $col=>$value) {
				$tempBoard = makeMove($board, $col, 1);
				if(checkIfWin($tempBoard))
					return $col;
			}
		}
	
		// from those available moves, choose one by random and return it
		return array_rand($arrOfPossMoves);
	}
	
	//takes board as param, returns true if win, false if not win.
	function checkIfWin($board){
		for($x = 0; $x < 7; $x++){
			for($y = 0; $y < 6; $y++){
				$token = $board[$y][$x];//current token being checked
				if($token == 0){
					//do nothing
				}
				else{
					$tmpX = $x;$tmpX = $x;$count = 0;
					while($board[$y][$tmpX] == $token){ //horizontal
						$tmpX++;$count++;
						if($count > 3)
							return true;
					}
	
					$tmpX = $x; $tmpY = $y; $count = 0; //vertical
					while ($board[$tmpY][$x] == $token){
						$tmpY++;$count++;
						if ($count > 3)
							return true;
					}
	
					$tmpX = $x; $tmpY = $y; $count = 0;
					while($board[$tmpY][$tmpX] == $token){ //upwards diagonal
						$tmpX++;$tmpY++;$count++;
						if($count > 3)
							return true;
					}
	
					$tmpX = $x; $tmpY = $y; $count = 0;
					while($board[$tmpY][$tmpX] == $token){ //downward diagonal
						$tmpX--;$tmpY++;$count++;
						if($tmpY <= 0){break;}
						if($count > 3)
							return true;
					}
				}
			}
		}
		return false;
	}
	
	function getWinArray($board){
		$winArray = array_fill(0, 8, 0);
	
		for($x = 0; $x < 7; $x++){
			for($y = 0; $y < 6; $y++){
				$token = $board[$y][$x];//current token being checked
				if($token == 0){
					//do nothing
				}
				else{
					$tmpX = $x;$tmpX = $x;$count = 0;
					$winArray[$count] = $x;
					$winArray[$count+1] = $y;
	
					while($board[$y][$tmpX] == $token){ //horizontal
						$winArray[$count*2] = $tmpX;
						$winArray[$count*2+1] = $y;
						$tmpX++;$count++;
						if($count > 3)
							return $winArray;
					}
	
					$tmpX = $x; $tmpY = $y; $count = 0; //vertical
					while ($board[$tmpY][$x] == $token){
						$winArray[$count*2] = $x;
						$winArray[$count*2+1] = $tmpY;
						$tmpY++;$count++;
						if ($count > 3)
							return $winArray;
					}
	
					$tmpX = $x; $tmpY = $y; $count = 0;
					while($board[$tmpY][$tmpX] == $token){ //upwards diagonal
						$winArray[$count*2] = $tmpX;
						$winArray[$count*2+1] = $tmpY;
						$tmpX++;$tmpY++;$count++;
						if($count > 3)
							return $winArray;
					}
	
					$tmpX = $x; $tmpY = $y; $count = 0;
					while($board[$tmpY][$tmpX] == $token){ //downward diagonal
						$winArray[$count*2] = $tmpX;
						$winArray[$count*2+1] = $tmpY;
						$tmpX--;$tmpY++;$count++;
						if($tmpY <= 0)
							break;
							if($count > 3)
								return $winArray;
					}
				}
			}
		}
		return $winArray = array_fill(0, 8, 0);
	}
	
	function checkIfTie($board){
		$topRow = $board[0];
		foreach($topRow as $key=>$value){
			if($value == 0)
				return false;	// not tie if there is >= one spot open
		}
		return true;
	}
	
	function print_array($arr){
		$x = 1;
		foreach ($arr as $row) {
			echo "Row: $x - | ";
			foreach($row as $col){
				echo $col."  | ";
			}
			echo "<br>";
			$x++;
		}
	}
	
	/*			Classes			*/
		
	class Board {
		// Used for the state of the game
		public $boardArr;
		public $strategy;
		
		public $rows = 6;
		public $cols = 7;
	}
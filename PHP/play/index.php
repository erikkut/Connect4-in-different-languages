<?php
	/* Allows the player to input a move, alters the board accordingly, and saves the altered board in a file */
	// Input: localhost:XXXX/play/?pid=XXXXXXXXXXXXX&move=X
	// Output:  {"response":true,"ack_move":{"slot":2,"isWin":false,"isDraw":false,"row":[]},"move":{"slot":4,"isWin":false,"isDraw":false,"row":[]}}

	/* Getting queries from url
	 * Reference: http://stackoverflow.com/questions/11480763/how-to-get-parameters-from-this-url-string
	 */
	$url = "https://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
	$parts = parse_url($url);
	parse_str($parts['query'], $query);

	/* getting vars from query string of url */
	$pid = $query['pid'];
	$move = $query['move'];
	
	require_once("commFunctions.php");
	
	if ($pid == "") {	// check if pid exists
		makeError("Pid not specified");
		return;
	} else if ($move == "") {	// check if move exists
		makeError("Move not specified");
		return;
	} else if(!doesPidExist($pid)) {	// check if file associated with pid exists
		makeError("Unknown pid");
		return;
	} else if(!withinRange($move)) {		// check if move is valid (within range)
		makeError("Invalid slot, " . $move);
		return;
	}
	
	//get array from file
	$myfile = fopen("../Writable/" . $pid . ".txt", "r+");
	$firstLine = fgets($myfile);
	$gameObject = json_decode($firstLine);
	fclose($myfile);
	
	require_once("board.php");
	
	// getting response ready
	$obj = new jsonObject();
	$arrObjs = checksAndMove($obj, $gameObject, $move, 1);//human player
	$obj = $arrObjs[0]; $gameObject = $arrObjs[1];
	$arrObjs = checksAndMove($obj, $gameObject, -1, 2);//AI
	$obj = $arrObjs[0]; $gameObject = $arrObjs[1];
	
	// saves altered board as json text, save into file and echo it
	$responseEncoded = json_encode($obj);
	echo $responseEncoded;//echoes json repsonse
	$boardEncoded = json_encode($gameObject);

	//for interactive purposes
	//echo nl2br("\n");
	//print_array($gameObject->boardArr);////////////////////////////////////////////////////////////////
	//echo nl2br("\n");
	
	addToTextDoc($pid, $boardEncoded);//changed this to only save board
	
	
	
	/*			Functions			*/
	
	//this function automizes the turn functionality.
	//PARAM: 	$obj is json object
	//			$gameObject is game board object
	//			$move is user specified move (CHANGED TO AI MOVE IN-FUNCTION)
	//			$who is int, 1 representing human player, 2 representing AI.
	function checksAndMove($obj, $gameObject, $move, $who){//RETURNS array containing [0]: json object and [1]: gameBoard object
		$loadedBoard = $gameObject->boardArr;
		if($who == 1){
			$obj->ack_move['slot'] = $move;
			$gameObject->boardArr = makeMove($loadedBoard, $move, $who);
		}
		else{
			$move = aiMove($loadedBoard, $gameObject->strategy);
			$obj->move['slot'] = $move;
			$gameObject->boardArr = makeMove($loadedBoard, $move, $who);
		}
		
		if(checkIfTie($gameObject->boardArr)){//game tied, set proper params
			$obj->ack_move['isDraw'] = true;
			$obj->move['isDraw'] = true;
			return [$obj, $gameObject];
		}
		else if(checkIfWin($gameObject->boardArr)){//game won, set winning coordinates
			$winningArray = getWinArray($gameObject->boardArr);
			$winningToken = $gameObject->boardArr[$winningArray[1]][$winningArray[0]];
			if($winningToken == 1){
				$obj->ack_move['isWin'] = true;
				$obj->ack_move['row'] = $winningArray;
			}
			else if($winningToken == 2){
				$obj->move['isWin'] = true;
				$obj->move['row'] = $winningArray;
			}
			return [$obj, $gameObject];
		}
		else if(checkIfTie($gameObject->boardArr)){//check for tie again, since AI moved
			$obj->ack_move['isDraw'] = true;
			$obj->move['isDraw'] = true;
			return [$obj, $gameObject];
		}
		else{
			return [$obj, $gameObject];
		}
	}
	
	function withinRange($move){
		require_once("board.php");
		$board = new Board();
		return $move >= 0 && $move < $board->cols;
	}
	
	function doesPidExist($pid){
		return file_exists("../Writable/" . $pid . ".txt");
	}
	
	
	/*			Classes			*/
	class jsonObject {
		public $response = true;
		public $ack_move = array("slot" => -1, "isWin" => false, "isDraw" => false, "row"=>array());	// User move
		public $move = array("slot" => -1, "isWin" => false, "isDraw" => false, "row"=>array());		// AI move
	}
	
	
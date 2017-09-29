<?php
	/* This file will create a new game and a new file to save the state of the game */
	// Input: localhost:XXXX/new/?strategy=XXXXX
	// Output: {"response":true,"pid":"XXXXXXXXXXXXX"}

	/* Getting queries from url
	 * Reference: http://stackoverflow.com/questions/11480763/how-to-get-parameters-from-this-url-string
	 */
	$url = "https://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]";
	$parts = parse_url($url);
	parse_str($parts['query'], $query);
	
	/* Getting vars from query string of url */
	$strategy = $query['strategy'];
	
	if (validateStrategy($strategy)) {
		// Generate response
		require_once("../play/commFunctions.php");
		$obj = new jsonObject();
		$obj->pid = uniqid();
		$responseEncoded = json_encode($obj);
		echo $responseEncoded;
		
		// Create a new game
		require_once("../play/board.php");
		$board = createBoard($strategy);
		//save the state of the game to the file (might just be the board, you should be able to recreate the game based off of this)
		$boardEncoded = json_encode($board);
		
		// Save to file
		//$finalString = $responseEncoded . "\n" . $boardEncoded;
		addToTextDoc($obj->pid, $boardEncoded);
	}
	
	
	
	/*			 Functions			 */
	
	function validateStrategy($strategy) {
		if($strategy != "Random" && $strategy != "Smart") {
			require_once("../play/commFunctions.php");
			makeError("Strategy not specified or wrong input");
			return false;
		}
		return true;
	}
	
	
	/*			Classes			*/
	
	class jsonObject {
		public $response = true;
		public $pid;
	}
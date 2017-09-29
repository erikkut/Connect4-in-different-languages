<?php
	/* This file will give information about the board but does not actually do anything functional */
	// Input: localhost:XXXX/info
	// Output: {"width":7,"height":6,"strategies":["Smart","Random"]}
	// Require board so that we can use it's information
	require_once("../play/board.php");
	$board = new Board();
	
	// Create an object to encode into json
	$gInfo = new gameInfo();
	
	$gInfo->width = $board->cols;
	$gInfo->height = $board->rows;
	$gInfo->strategies= array("Smart", "Random");
	echo json_encode($gInfo);
	
	/*			Classes			*/
	
	class gameInfo {
		public $width = "";
		public $height = "";
		public $strategies = "";
	}
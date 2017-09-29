<?php
	/* Functions */

	function makeError($msg) {
		$err = new errorInput();
		$err->reason = $msg;
		echo json_encode($err);
	}
	
	/* Validates parameters, opens a file with the name of the pid.txt, and writes the json string to that file */
	function addToTextDoc($pid, $jsonString) {
		if(file_exists ("../Writable/" . $pid . ".txt")){
			file_put_contents("../Writable/" . $pid . ".txt", "");
		}
		if (!empty($pid) && !empty($jsonString)) {
			$fp = fopen("../Writable/" . $pid . ".txt", "a");
			fwrite($fp, $jsonString);
			fclose($fp);
		}
	}

	/* Classes */

	/* Error to be printed as JSON */
	class errorInput {
		public $response = false;
		public $reason = "";
	}
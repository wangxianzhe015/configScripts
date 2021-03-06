<?php
	/********************************
	* MySQL Database Dump Script
	* 
	* Intended to assist in the transfer
	* or backup of wordpress sites.
	* 
	* INSTRUCTIONS:
	*
	*	1)	Make a new folder in the wordpress
	*		root (for example, example.com/dbdump).
	*
	*	2) 	Place this script in that new folder.
	*
	*	3)	Put your IP addresses in the config 
	*		section.
	*
	*	4)	Run the script, and the database 
	*		will be downloaded.
	* 
	* Created by Ben Yanke
	* https://github.com/benyanke/
	*
	* Last modified on 8/18/2016
	********************************/

	/********************************
	* Configuration Settings
	********************************/
	
	// Only allow connections from IP adresses
	// Add as many lines as you need

	$allowableIps[] = "24.240.110.45"; // Office LAN
	$allowableIps[] = "24.183.104.66"; // Office Server1
	$allowableIps[] = "24.240.110.99"; // Office Server2
	$allowableIps[] = "71.13.249.254"; // Home
	
	// Sample IPs for documentation
	$allowableIps[] = "192.0.2.34"; // sample WAN IP
	$allowableIps[] = "198.51.100.98"; // sample WAN IP
	$allowableIps[] = "203.0.113.195"; // sample WAN IP
	
	
	/********************************
	* Optional Configuration Settings
	********************************/
	// You shouldn't need to change these
	
	// Path to wp-config.php
	$pathToWpConfig = "../wp-config.php";
	
	/********************************
	* Don't edit below this line
	********************************/
	
	// Get the IP from the client
	$clientIp = $_SERVER["REMOTE_ADDR"];
	
	$validClient = false;
	foreach($allowableIps as $ip) {
		if ($clientIp == $ip) {
			$validClient = true;
			break;
		}
	}
	
	if (! $validClient) {
		error("Client IP ($clientIp) was not valid.");
	}
	
	/*
	DB Constants from wp-config.php
	DB_NAME
	DB_USER
	DB_PASSWORD
	DB_HOST
	*/
	
	/********************************
	* Functions
	********************************/
	
	function error($message) {
		echo "<h2>There has been a fatal error</h2>"
		echo "<h3>" . $message . "</h3>"
		
		die();
	}
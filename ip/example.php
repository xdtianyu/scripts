#!/usr/local/bin/php
<?php

$api_key = "INSERT_YOUR_OWN_API_KEY_HERE";

require "dbip-client.class.php";

$ip_addr = $argv[1]
or die("usage: {$argv[0]} <ip_address>\n");

try {

	$dbip = new DBIP_Client($api_key);

	echo "keyinfo:\n";
	foreach ($dbip->Get_Key_Info() as $k => $v) {
		echo "{$k}: {$v}\n";
	}

	echo "\naddrinfo:\n";
	foreach ($dbip->Get_Address_Info($ip_addr) as $k => $v) {
		echo "{$k}: {$v}\n";
	}

} catch (Exception $e) {

	die("error: {$e->getMessage()}\n");

}

?>

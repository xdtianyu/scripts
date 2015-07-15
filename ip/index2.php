<?php
    $api_key = "YOUR_DB_IP_KEY(https://db-ip.com/api/)";
    require "dbip-client.class.php";

    $ip=$_SERVER["REMOTE_ADDR"];
    echo $ip;
?>

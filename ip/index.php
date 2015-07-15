<?php
    require "dbip-client.class.php";
    require "IP.class.php";

    $api_key = "YOUR_DB_IP_KEY(https://db-ip.com/api/)";
    if (isset($_POST['geo']))
    {
        $ip_addr = $_POST['geo'];
    }
    else
    {
        $ip_addr = null;
    }
    $ip=$_SERVER['REMOTE_ADDR'];

    if (empty($ip_addr)) {
        echo $ip;
    } else {
        $dbip = new DBIP_Client($api_key);
        foreach ($dbip->Get_Address_Info($ip_addr) as $k => $v) {
#            echo "$k:$v,";
            if ($k=="country" && $v=="CN") {
                $finds = IP::find($ip_addr);
                $result = "";
                foreach ($finds as $res) {
                    if (!empty($res)) {
                        if ($result!=$res)
                            $result = empty($result)?$res:"$result,"."$res";
                    }
                }
                echo $result;
                break;
            }
            if ($k=="address") {
                echo "";
            } else if ($k=="city") {
                echo "$v";
            } else {
                echo "$v,";
            }
        }
    }
?>

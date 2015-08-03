<?php
    # I recommend you use HTTPS and Basic access authentication to protect this file
    $method = $_SERVER['REQUEST_METHOD'];
    switch ($method) {
        case 'POST':
            $name = $_POST['client'];
            $time = $_POST['time'];
            $extra = $_POST['extra'];
#            echo $extra;

            // write extra to file.
            $filename = $name;
            echo $filename;
            $fp = fopen($filename.".txt","a");
            if( $fp == false ){
                echo "Open file error";
            }else{
                fwrite($fp,$extra);
                fclose($fp);
                shell_exec("./speedtest.py . ".escapeshellarg($filename)." ".escapeshellarg($time)." >>/tmp/speedtest.txt 2>&1 &");    
            }
            break;
        case 'GET':
            echo '<head><meta http-equiv="refresh" content="0; url=home.htm" /></head>';
        break;
    }
?>

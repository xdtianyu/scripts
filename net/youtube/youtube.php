<?php
    # I recommend you use HTTPS and Basic access authentication to protect this file.
    $method = $_SERVER['REQUEST_METHOD'];
    switch ($method) {
        case 'POST':
            $input = isset($_POST['urls'])?$_POST['urls']:"";
            if (strlen($_POST['urls'])!=0) {
                $urls = explode("\n", str_replace("\r", "", $input));
                echo json_encode($urls, JSON_UNESCAPED_SLASHES);
                #shell_exec("echo '".json_encode($urls)."' >>/tmp/out.txt 2>&1 &");
                foreach ($urls as $url) {
                    shell_exec("cd /home/downloads;./youtube '".$url."' >>/tmp/youtube.txt 2>&1 &");
                }
                exit;
            } else {
                echo json_encode(array("error" => "empty url"));
            }
            break;
        case 'GET':
            echo '<form method="post" action="'.htmlspecialchars($_SERVER["PHP_SELF"]).'">
    URL:<br/> 
    <textarea name="urls" rows="5" cols="50"></textarea><br/>
    <input type="submit">
</form>';
            break;
    }
?>

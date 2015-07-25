<?php
    # I recommend you use HTTPS and Basic access authentication to protect this file.
    $method = $_SERVER['REQUEST_METHOD'];
    switch ($method) {
        case 'POST':
            $input = isset($_POST['files'])?$_POST['files']:"";
            if (strlen($_POST['files'])!=0) {
                $files = explode("\n", str_replace("\r", "", $input));
                echo json_encode($files, JSON_UNESCAPED_SLASHES);
                #shell_exec("echo '".json_encode($files)."' >>/tmp/out.txt 2>&1 &");
                foreach ($files as $file) {
                    shell_exec("cd /home/downloads;rm ./'".$file."' >>/tmp/rm.txt 2>&1 &");
                }
                exit;
            } else {
                echo json_encode(array("error" => "empty file"));
            }
            break;
        case 'GET':
            echo '<form method="post" action="'.htmlspecialchars($_SERVER["PHP_SELF"]).'">
    FILES:<br/> 
    <textarea name="files" rows="5" cols="50"></textarea><br/>
    <input type="submit">
</form>';
            break;
    }
?>

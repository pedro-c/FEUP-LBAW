<?php

include_once "../../database/files.php";
include_once "../../config/init.php";

if(isset($_POST['file_id'])){

    $file = getFileTag($_POST['file_id']);
    print json_encode($file);
}
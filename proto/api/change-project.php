<?php

include_once "../config/init.php";

if(isset($_POST['project_id'])){

    $_SESSION['project_id']=$_POST['project_id'];
    return json_encode($_SESSION['project_id']);
}

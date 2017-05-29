<?php


include_once "../../database/dashboard.php";
include_once "../../config/init.php";

if(isset($_POST['description'])){
    $return = changeProjectDescription($_POST['description'],$_SESSION['project_id']);
    print json_encode($return);
}
<?php


include_once "../../database/dashboard.php";
include_once "../../config/init.php";

if(isset($_POST['name'])){
    $return = changeProjectName($_POST['name'],$_SESSION['project_id']);
    print json_encode($return);
}
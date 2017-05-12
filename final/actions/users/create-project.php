<?php
include_once('../../config/init.php');
include_once('../../database/users.php');

if(isset($_SESSION['user_id']) && isset($_POST['projectName'])){
    createProject($_POST['projectName']);
}



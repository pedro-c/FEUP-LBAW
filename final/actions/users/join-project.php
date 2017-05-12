<?php
include_once('../../config/init.php');
include_once('../../database/users.php');

if(isset($_SESSION['user_id']) && isset($_POST['projectId'])){
    joinProject($_SESSION['user_id'], $_POST['projectId']);
}



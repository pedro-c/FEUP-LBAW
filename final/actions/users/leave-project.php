<?php
include_once('../../config/init.php');
include_once('../../database/users.php');

if(isset($_SESSION['user_id']) && isset($_POST['projectId'])){
    //TODO: CHECK IF user is coordinator, and if only coordinator, delete project or make someone coordinator

    leaveProject($_SESSION['user_id'], $_POST['projectId']);
}

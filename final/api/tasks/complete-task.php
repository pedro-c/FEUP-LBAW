<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskId'])) {

    print json_encode(completeTask(htmlspecialchars($_POST['taskId'])));

}
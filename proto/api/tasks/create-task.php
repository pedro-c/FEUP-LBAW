<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['action'])) {
    if ($_POST['action'] == 'create-task') {
        $taskId=createTask();
        print json_encode($taskId);
    }
}
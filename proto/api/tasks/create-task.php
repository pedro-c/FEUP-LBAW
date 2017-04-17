<?php
include_once('../../database/tasks.php');

if (isset($_POST['action'])) {
    if ($_POST['action'] == 'create-task') {
        $taskId=getTaskDetails();
        print json_encode($taskId);
    }
}
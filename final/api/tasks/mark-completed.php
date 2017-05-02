<?php
include_once('../../database/tasks.php');

if (isset($_POST['action'])) {
    if ($_POST['action'] == 'complete-task') {
        $taskId=completeTask();
        print json_encode($taskId);
    }
}
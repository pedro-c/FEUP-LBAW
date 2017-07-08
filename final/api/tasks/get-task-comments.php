<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskId'])) {

    $taskId = $_POST['taskId'];
    $taskComments = null;
    $taskComments = getTaskComments(htmlspecialchars($taskId));

    print json_encode([$taskComments]);
}


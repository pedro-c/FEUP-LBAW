<?php
include_once('../../database/tasks.php');
include_once('../../config/init.php');

if (isset($_POST['taskId'])) {

    $taskId = $_POST['taskId'];

    $taskDetails = getTaskDetails($taskId);
    $taskTags = getTagFromTaskId([$taskId]);

    print json_encode([$taskDetails, $taskTags]);
}
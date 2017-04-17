<?php
include_once('../../database/tasks.php');
include_once('../../database/projects.php');
include_once('../../config/init.php');

if (isset($_POST['taskId'])) {

    $taskId = $_POST['taskId'];

    $taskDetails = getTaskDetails($taskId);
    $taskTags = getTagFromTaskId($taskId);
    $taskAssignedName = getTaskAssignedName($taskId);
    $projectMembers = getProjectMembersNames(1,$_SESSION['user_id']);

    print json_encode([$taskDetails, $taskTags, $taskAssignedName,$projectMembers]);
}


<?php
include_once('../../database/tasks.php');

if (isset($_POST['taskAssign'])) {

    $taskId=setTaskAssigned($_POST['taskAssign']);

}


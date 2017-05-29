<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskAssign'])) {
    if (isset($_POST['taskId'])) {
        setTaskAssigned(htmlspecialchars($_POST['taskAssign']), htmlspecialchars($_POST['taskId']));
    }
}


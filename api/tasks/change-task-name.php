<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskName'])) {
    if (isset($_POST['taskId'])) {
        setTaskName(htmlspecialchars($_POST['taskName']), htmlspecialchars($_POST['taskId']));
    }
}

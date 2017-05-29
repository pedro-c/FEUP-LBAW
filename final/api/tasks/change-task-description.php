<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskDescription'])) {
    if (isset($_POST['taskId'])) {
        setTaskDescription(htmlspecialchars($_POST['taskDescription']), htmlspecialchars($_POST['taskId']));
    }
}
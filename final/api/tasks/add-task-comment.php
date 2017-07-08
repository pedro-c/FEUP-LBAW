<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskComment'])) {
    if (isset($_POST['taskId'])) {
        addTaskComment(htmlspecialchars($_POST['taskComment']), htmlspecialchars($_POST['taskId']));
    }
}
<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskDescription'])) {
    if (isset($_POST['taskId'])) {
        setTaskDescription($_POST['taskDescription'], $_POST['taskId']);
    }
}
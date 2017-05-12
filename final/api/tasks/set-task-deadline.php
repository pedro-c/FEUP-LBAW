<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskDeadline'])) {
    if (isset($_POST['taskId'])) {
        setTaskDeadline($_POST['taskDeadline'], $_POST['taskId']);
    }
}
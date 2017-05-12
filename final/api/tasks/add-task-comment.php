<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskComment'])) {
    if (isset($_POST['taskId'])) {
        addTaskComment($_POST['taskComment'], $_POST['taskId']);
    }
}
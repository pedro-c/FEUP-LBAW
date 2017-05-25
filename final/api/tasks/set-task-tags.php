<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskTag'])) {
    if (isset($_POST['taskId'])) {
        deleteTaskTags($_POST['taskTag']);
        addTaskTag($_POST['taskTag'],$_POST['taskId']);
    }
}
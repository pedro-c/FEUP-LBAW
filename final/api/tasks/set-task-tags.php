<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskTags'])) {
    if (isset($_POST['taskId'])) {
        deleteTaskTags($_POST['taskTags']);
        addTaskTag($_POST['taskTags'],$_POST['taskId']);
    }
}
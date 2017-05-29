<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskId'])) {

    completeTask(htmlspecialchars($_POST['taskId']));

}
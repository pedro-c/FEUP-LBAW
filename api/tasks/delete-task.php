<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if (isset($_POST['taskId'])) {

    deleteTask(htmlspecialchars($_POST['taskId']));

}
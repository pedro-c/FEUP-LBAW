<?php

include_once('../../database/meetings.php');
include_once('../../config/init.php');

if(isset($_POST['title']) && isset($_POST['date']) && isset($_POST['time']))
{
    $title = $_POST['title'];
    $description = $_POST['description'];
    $date = $_POST['date'];
    $time = $_POST['time'];
    $duration = $_POST['duration'];

    scheduleMeeting($title,$description, $date,$time,$duration,$_SESSION['user_id'],$_SESSION['project_id']);
    header('Location: ' . $_SERVER['HTTP_REFERER']);

}
else{
    $_SESSION['error_messages'][] = '<br>'.'You are not allowed to schedule a meeting without fill title, date and time fields';
    header('Location: ' . $_SERVER['HTTP_REFERER']);
}
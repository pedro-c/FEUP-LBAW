<?php

include_once('../../database/meetings.php');
include_once('../../config/init.php');

if(isset($_POST['title']) && isset($_POST['date']) && isset($_POST['time']) && isset($_POST['invited_users']))
{
    $title = $_POST['title'];
    $description = $_POST['description'];
    $date = $_POST['date'];
    $time = $_POST['time'];
    $duration = $_POST['duration'];
    $invited_users = $_POST['invited_users'];


    $meeting_id = scheduleMeeting($title,$description, $date,$time,$duration,$_SESSION['user_id'],$_SESSION['project_id']);
   //inviteUserToMeeting($meeting_id, $invited_users);
    header('Location: ' . $_SERVER['HTTP_REFERER']);

}
else{
    $_SESSION['error_messages'][] = '<br>'.'You are not allowed to schedule a meeting without fill title, date and time fields. You must invite at least one member.';
    header('Location: ' . $_SERVER['HTTP_REFERER']);
}
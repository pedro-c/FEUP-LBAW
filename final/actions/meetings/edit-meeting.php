<?php

include_once('../../database/meetings.php');
include_once('../../database/common.php');
include_once('../../database/tag.php');
include_once('../../database/files.php');
include_once('../../config/init.php');


$title = htmlspecialchars($_POST['title']);
$description = htmlspecialchars($_POST['description']);
$date = $_POST['date'];
$time = $_POST['time'];
$duration = $_POST['duration'];
$meeting_id = $_POST['id'];

editMeetingInfo($title, $description, $date, $time, $duration, $meeting_id);
$_SESSION['success_messages'][] = '<br>' . 'Edited Meeting successful';
header('Location: ' . $_SERVER['HTTP_REFERER']);

<?php

include_once('../../database/meetings.php');
include_once('../../database/common.php');
include_once('../../database/tag.php');
include_once('../../database/files.php');
include_once('../../config/init.php');


$title = $_POST['title'];
echo $title;
$description = $_POST['description'];
echo $description;
$date = $_POST['date'];
echo $date;
$time = $_POST['time'];
echo $time;
$duration = $_POST['duration'];
echo $duration;
$meeting_id = $_POST['id'];
echo 'meeting'.$meeting_id;

editMeetingInfo($title, $description, $date, $time, $duration, $meeting_id);
$_SESSION['success_messages'][] = '<br>' . 'Edited Meeting successful';
header('Location: ' . $_SERVER['HTTP_REFERER']);

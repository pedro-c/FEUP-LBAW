<?php
include_once('../../config/init.php');
include_once("../../database/team.php");

$project_id = $_POST['idProject'];
$user_email = $_POST['userEmail'];
$insert_result = inviteMember($user_email, $project_id); //TODO When email already exists, sends error

//TODO SEND EMAIL. Still sends error
$subject = "Invite to Project";
$message = "You have been invited to a project";
$headers = "From: direkt@fe.up.pt";
$send_result = mail($user_email, $subject, $message, $headers);

$jsonObject->insert_result = $insert_result;
$jsonObject->send_result = $send_result;

echo json_encode($jsonObject);
//header('Location: ' . $_SERVER['HTTP_REFERER']);
 ?>

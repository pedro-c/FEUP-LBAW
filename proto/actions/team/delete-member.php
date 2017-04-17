<?php
include_once('../../config/init.php');
include_once('../../database/team.php');

$id_project = $_POST['project_id'];
$id_member = $_POST['user_id'];
removeMember($id_member, $id_project);

header('Location: ' . $_SERVER['HTTP_REFERER']);
 ?>

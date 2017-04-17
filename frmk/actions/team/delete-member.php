<?php
ini_set("display_errors", true); error_reporting(E_ALL);
$id_project = $_POST['project_id'];
$id_user = $_POST['user_id'];

//TODO Have script to open database as conn instead of "hardcoding"
$conn = new PDO('pgsql:host=dbm.fe.up.pt;dbname=lbaw1614', 'lbaw1614', 'yz54fi76');
$sql_remove_member =
" DELETE FROM user_project
WHERE id_user = ? AND id_project = ?;";

$stmt = $conn->prepare($sql_remove_member);
$stmt->execute(array($id_user, $id_project));
header('Location: ' . $_SERVER['HTTP_REFERER']);
 ?>

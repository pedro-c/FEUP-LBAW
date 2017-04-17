<?php
$id_project = $_POST['idProject'];
$id_user = $_POST['idUser'];

//TODO Have script to open database as conn instead of "hardcoding"
$conn = new PDO('pgsql:host=dbm.fe.up.pt;dbname=lbaw1614', 'lbaw1614', 'yz54fi76');

$sql_demote_member =
"UPDATE user_project
SET is_coordinator = FALSE
WHERE id_user = ? AND id_project = ?;";

$stmt = $conn->prepare($sql_set_coordinator);
$stmt->execute(array($id_user, $id_project));
 ?>

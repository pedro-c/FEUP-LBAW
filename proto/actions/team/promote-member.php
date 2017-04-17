<?php
  $id_project = $_POST['idProject'];
  $id_user = $_POST['idUser'];

  //TODO Have script to open database as conn instead of "hardcoding"
  $conn = new PDO('pgsql:host=dbm.fe.up.pt;dbname=lbaw1614', 'lbaw1614', 'yz54fi76');

  $sql_set_coordinator =
  "UPDATE user_project
  SET is_coordinator = TRUE
  WHERE id_user = ? AND id_project = ?;";

  $stmt = $conn->prepare($sql_set_coordinator);
  $stmt->execute(array($id_user, $id_project));

  //TODO Count number of rows changed to check if there was an error?

 ?>

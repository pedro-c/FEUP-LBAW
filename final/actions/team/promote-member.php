<?php
include_once('../../config/init.php');
include_once $BASE_DIR . 'database/team.php';

  $id_project = $_POST['project_id'];
  $id_user = $_POST['user_id'];

  $sql_set_coordinator =
  "UPDATE user_project
  SET is_coordinator = TRUE
  WHERE id_user = ? AND id_project = ?;";

  $stmt = $conn->prepare($sql_set_coordinator);

  if($stmt->execute(array($id_user, $id_project))) {
    $_SESSION['success_messages'][] = '<br>'.'Promoted Member with success';
  } else {
    $_SESSION['error_messages'][] = '<br>'.'Error promoting user';
  }
  header('Location: ' . $_SERVER['HTTP_REFERER']);
 ?>

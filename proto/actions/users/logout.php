<?php
  include_once('../../config/init.php');
  
  session_destroy();
  $_SESSION['success_messages'][] = '<br>'.'Logout successful';
  header('Location: ' . $BASE_URL . "pages/authentication.php");
?>

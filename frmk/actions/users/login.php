<?php
  include_once('../../config/init.php');
  include_once('../../database/users.php');

  if (!$_POST['email'] || !$_POST['password']) {
    $_SESSION['error_messages'][] = '<br>'.'Invalid login';
    $_SESSION['form_values'] = $_POST;
    header('Location: ' . $_SERVER['HTTP_REFERER']);
    exit;
  }

  $email = $_POST['email'];
  $password = $_POST['password'];
  
  if (isLoginCorrect($email, $password)) {
    $_SESSION['email'] = $email;
    $_SESSION['success_messages'][] = '<br>'.'Login successful';
    header('Location: ../../pages/PIU/UI2.php');
  } else {
    $_SESSION['error_messages'][] = '<br>'.'Login failed. Invalid email or password. Try again';
    header('Location: ' . $_SERVER['HTTP_REFERER']);
  }

?>

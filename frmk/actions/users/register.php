<?php
  include_once('../../config/init.php');
  include_once('../../database/users.php');

  if (!$_POST['email'] || !$_POST['username'] || !$_POST['password']) {
    $_SESSION['error_messages'][] = '<br>'.'All fields are mandatory';
    $_SESSION['form_values'] = $_POST;
    header("Location:".$_SERVER['HTTP_REFERER']);
    exit;
  }

  $email = $_POST['email'];
  $username = $_POST['username'];
  $password = $_POST['password'];
  $name = $_POST['name'];

  try{
    createUser($name, $email, $username, $password);
  }
  catch (PDOException $e){
      if (strpos($e->getMessage(), 'users_pkey') !== false) {
          $_SESSION['error_messages'][] = '<br>'.'Duplicated email';
          $_SESSION['field_errors']['email'] = '<br>'.'Email already exists';
      }
      else $_SESSION['error_messages'][] = '<br>'.'Error creating user';

      $_SESSION['form_values'] = $_POST;
      header('Location: ' . $_SERVER['HTTP_REFERER']);
      exit;
  };

  $_SESSION['email'] = $email;
  $_SESSION['username'] = $username;
  $_SESSION['success_messages'][] = '<br>'.'User registered successfully';
  $_SESSION['success_messages'][] = '<br>'.'User registered successfully';

  header('Location: ../../pages/PIU/UI2.php');
?>

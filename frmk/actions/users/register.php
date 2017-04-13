<?php
  include_once('../../config/init.php');
  include_once($BASE_DIR .'database/users.php');  

  if (!$_POST['email'] || !$_POST['username'] || !$_POST['password']) {
    $_SESSION['error_messages'][] = 'All fields are mandatory';
  //  $_SESSION['form_values'] = $_POST;
    header("Location:".$_SERVER['HTTP_REFERER']);
    exit;
  }

  $email = $_POST['email']; //strip_tags?
  $username = $_POST['username'];
  $password = $_POST['password'];

    if(createUser($email, $username, $password)){
        $_SESSION['email'] = $email;
        header('Location: ../../pages/PIU/UI1.php');
    }
    else $_SESSION['error_messages'][] = 'Error creating user';
  
    /*if (strpos($e->getMessage(), 'users_pkey') !== false) {
      $_SESSION['error_messages'][] = 'Duplicate username';
      $_SESSION['field_errors']['username'] = 'Username already exists';
    }
    else $_SESSION['error_messages'][] = 'Error creating user';

    $_SESSION['form_values'] = $_POST;
    header("Location: $BASE_URL" . 'pages/users/register.php');
    exit;

  $_SESSION['success_messages'][] = 'User registered successfully';  
  header("Location: $BASE_URL");*/
?>

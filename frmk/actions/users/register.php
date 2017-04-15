<?php
  include_once('../../config/init.php');
  include_once('../../database/users.php');

  if (!$_POST['email'] || !$_POST['username'] || !$_POST['password'] || !($_POST['new-project'] || $_POST['project'])) {
    $_SESSION['error_messages'][] = '<br>'.'All fields are mandatory except Project fields ';
    $_SESSION['form_values'] = $_POST;
    header("Location:".$_SERVER['HTTP_REFERER']);
    exit;
  }

    $email = $_POST['email'];
    $username = $_POST['username'];
    $password = $_POST['password'];
    $name = $_POST['name'];
    $answer = $_POST['project'];
    $project_id = $_POST['enterproject'];

    if($answer == "join"){
        if(!checkForInvitation($email,$project_id)){
            $_SESSION['error_messages'][] = '<br>'.'Not allowed to enter this project';
            exit;
        }
    }
    else if($answer == "create"){
        //createProject
    }

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

  $_SESSION['id_project'] = $project_id;
  $_SESSION['email'] = $email;
  $_SESSION['id'] = getUserId($email);
  $_SESSION['username'] = $username;
  $_SESSION['success_messages'][] = '<br>'.'User registered successfully';
  $_SESSION['success_messages'][] = '<br>'.'User registered successfully';

  joinProject($_SESSION['id'], $_SESSION['id_project']);

   header('Location: ../../pages/PIU/UI2.php');

?>

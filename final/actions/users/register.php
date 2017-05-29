<?php
  include_once('../../config/init.php');
  include_once('../../database/users.php');
  include_once('../../database/projects.php');
  include_once('../../database/team.php');

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
    $project_code = $_POST['enterproject']; //TODO Mudar para project code
    $project_name = $_POST['newProjectName'];

    $invited_user = getInvitedMemberFromCode($project_code);

    if($answer == "join"){
        if(getUsername($email) != null) {
            $_SESSION['error_messages'][] = '<br>'.'User already registered';
            header('Location: ' . $_SERVER['HTTP_REFERER']);
            exit();
        }
        if($invited_user == null){
            $_SESSION['error_messages'][] = '<br>'.'Not allowed to enter this project' + $project_code;
            header('Location: ' . $_SERVER['HTTP_REFERER']);
            exit();
        }
    }
    else if($answer == "create"){
        $project_id = createNewProject($project_name);
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

  if($answer == "join") {
    $_SESSION['project_id'] = $invited_user['id_project'];
  } elseif ($answer == "create") {
    $_SESSION['project_id'] = $project_id;
  }
  $_SESSION['email'] = $email;
  $_SESSION['user_id'] = getUserId($email);
  $_SESSION['username'] = $username;
  $_SESSION['success_messages'][] = '<br>'.'User registered successfully';
  $_SESSION['success_messages'][] = '<br>'.'User registered successfully';

  if($answer == "join"){
    joinProjectInvited($_SESSION['user_id'], $_SESSION['project_id']);
  } else {
    joinProject($_SESSION['user_id'], $project_id, TRUE);
  }

  header('Location: ../../pages/dashboard.php');

?>

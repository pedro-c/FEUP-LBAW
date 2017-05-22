<?php
include_once('../../config/init.php');
include_once('../../database/users.php');
include_once('../../database/team.php');

if(isset($_SESSION['user_id']) && isset($_POST['userCode'])){

    $invitedInfos = getInvitedMemberFromCode($_POST['userCode']);
    if($invitedInfos != null) {
      if(strcmp($invitedInfos['email'], $_SESSION['email']) == 0) {
        joinProject($_SESSION['user_id'], $invitedInfos['id_project']);
      } else {
        echo FALSE;
      }
    } else {
      echo FALSE;
    }
}
?>

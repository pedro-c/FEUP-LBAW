<?php
include_once('../../config/init.php');
include_once('../../database/users.php');
include_once('../../database/team.php');
include_once('../../database/projects.php');

if(isset($_SESSION['user_id']) && isset($_POST['projectId'])){
    //TODO: CHECK IF user is coordinator, and if only coordinator, delete project or make someone coordinator
    $team_members = getTeamMembers($_POST['projectId']);
    $num_members = count($team_members);
    $num_coordinators = getNumCoordinators($_POST['projectId']);
    $is_coordinator = getUserInfo($_SESSION['user_id'])['is_coordinator'];

    if($num_coordinators == 1) {
        if($num_members == 1) {
          deleteProject($_POST['projectId']);
          if(isUserWithNoProjects()) {
              echo "NoProjects";
          } else {
              echo "Delete";
          }
        } elseif($num_members > 1) {
            if($is_coordinator) {
              echo leaveProject($_SESSION['user_id'], $_POST['projectId']);
              if(isUserWithNoProjects()) {
                  echo "NoProjects";
              }
            } else {
              echo "Nominate";
            }
        } else {
          echo "Error";
        }
    } elseif($num_coordinators > 1) {
        echo leaveProject($_SESSION['user_id'], $_POST['projectId']);
        if(isUserWithNoProjects()) {
            echo "NoProjects";
        }
    } else {
        echo "Error";
    }
} else {
  echo "Not set";
}

function isUserWithNoProjects() {
    $user_projects = getUserProjects($_SESSION['user_id']);
    $num_user_projects = count($user_projects);
    if($num_user_projects == 0) {
        return TRUE;
    } else {
        return FALSE;
    }
}

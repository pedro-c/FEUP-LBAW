<?php
include_once('../../config/init.php');
include_once('../../database/projects.php');

$list_projects = getUserProjects($_SESSION['user_id']);
if(count($list_projects) > 0) {
  $_SESSION['project_id'] = $list_projects[0]['id_project'];
}
?>

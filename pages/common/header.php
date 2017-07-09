<?php

include_once '../config/init.php';
include_once('../database/users.php');
include_once('../database/projects.php');
include_once('../database/common.php');

if(!isset($_SESSION['user_id'] )){
    header("Location: ". $BASE_URL . "pages/authentication.php");
}


$firstProjectName = getProjectName($_SESSION['project_id']);
$name = getUserNameById($_SESSION['user_id']);
$projects = getUserProjects($_SESSION['user_id']);
$photo = getPhoto($_SESSION['user_id']);

$smarty->assign('firstProjectName',$firstProjectName);
$smarty->assign('projects',$projects);
$smarty->assign('name',$name);
$smarty->assign('photo',$photo);
$smarty->display($BASE_DIR."templates/header.tpl");
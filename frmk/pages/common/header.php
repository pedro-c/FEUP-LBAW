<?php

include_once '../config/init.php';
include_once('../database/users.php');
include_once('../database/projects.php');

$firstProjectName = getProjectName(getFirstUserProject($_SESSION['user_id']));
$name = getUserNameById($_SESSION['user_id']);
$projects = getUserProjects($_SESSION['user_id']);

$smarty->assign('firstProjectName',$firstProjectName);
$smarty->assign('projects',$projects);
$smarty->assign('name',$name);
$smarty->display($BASE_DIR."templates/header.tpl");
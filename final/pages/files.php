<?php
include_once "common/header.php";

include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/projects.php');
include_once($BASE_DIR .'database/files.php');
include_once($BASE_DIR .'database/tag.php');

$user_id = $_SESSION['user_id'];
$project = $_SESSION['project_id'];

$files = getAllFiles($project);
$current_date = date('m/d/Y h:i:s a', time());
$tags = getAllTagNames();
$smarty->assign('tags',$tags);
$smarty->assign('currentDate',$current_date);
$smarty->assign('files',$files);
$smarty->assign($project, 'project_id');
$smarty->display($BASE_DIR . 'templates/files.tpl');



include_once "common/footer.php";
?>
t
<?php
include_once "common/header.php";
include_once($BASE_DIR .'database/meetings.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/projects.php');
include_once($BASE_DIR .'database/team.php');
include_once($BASE_DIR .'database/tasks.php');

$user_id = $_SESSION['user_id'];
$project = $_SESSION['project_id'];

$smarty->display($BASE_DIR . 'templates/files.tpl');


include_once "common/footer.php";
?>
t
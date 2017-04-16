<?php
include_once "common/header.php";
include_once($BASE_DIR .'database/meetings.php');
include_once($BASE_DIR .'database/users.php');

$project = $_SESSION['project_id'];
$meetings = getFutureMeetings($project);

$smarty->assign('meetings',$meetings);
$smarty->display($BASE_DIR . 'templates/meetings.tpl');


include_once "common/footer.php";
?>
t
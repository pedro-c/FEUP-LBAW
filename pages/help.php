<?php
include_once "common/header.php";
include_once($BASE_DIR .'database/meetings.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/projects.php');
include_once($BASE_DIR .'database/team.php');
include_once($BASE_DIR .'database/tasks.php');
include_once($BASE_DIR .'database/tag.php');
include_once($BASE_DIR .'database/common.php');


$smarty->display($BASE_DIR . 'templates/help.tpl');


include_once "common/footer.php";
?>
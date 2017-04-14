<?php
include_once "common/header.php";
include_once($BASE_DIR .'database/tasks.php');

//$projectId=$_GET['project_id'];

$tasks = getAllTasksFromProject([1]);

$smarty->assign('tasks', $tasks);
$smarty->display($BASE_DIR . 'templates/tasks/tasks.tpl');


?>




<?php
include_once "common/footer.html";
?>



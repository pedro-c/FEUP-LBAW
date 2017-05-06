<?php
include_once "common/header.php";
include_once($BASE_DIR .'database/tasks.php');

$projectId=$_SESSION['project_id'];

$tasks = getAllTasksFromProject($projectId);

$smarty->assign('tasks', $tasks);
$smarty->display($BASE_DIR . 'templates/tasks/tasks.tpl');

?>

<?php
include_once "common/footer.php";
?>



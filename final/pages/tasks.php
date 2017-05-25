<?php
include_once "common/header.php";
include_once($BASE_DIR .'database/tag.php');
include_once($BASE_DIR .'database/tasks.php');

$projectId=$_SESSION['project_id'];

$tasks = getAllTasksFromProject($projectId);
$projectTags = getTagsFromProject();


$smarty->assign('tasks', $tasks);
$smarty->assign('projectTags', $projectTags);
$smarty->display($BASE_DIR . 'templates/tasks/tasks.tpl');

?>

<?php
include_once "common/footer.php";
?>



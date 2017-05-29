<?php
ob_start();
include_once "common/header.php";
include_once($BASE_DIR .'database/tag.php');
include_once($BASE_DIR .'database/tasks.php');

if(!isset($_SESSION['user_id']))
    header('Location: '. $BASE_URL . 'pages/authentication.php');
if(!isset($_SESSION['project_id']))
    header('Location: '. $BASE_URL . 'pages/profile.php');
ob_end_flush();
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

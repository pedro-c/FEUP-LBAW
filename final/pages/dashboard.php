<?php
include_once "common/header.php";
include_once "../database/projects.php";
include_once "../database/files.php";
include_once "../database/common.php";
include_once "../database/users.php";
include_once "../database/meetings.php";
include_once "../database/team.php";
include_once "../database/tasks.php";
include_once "../database/forum.php";

$projectName = getProjectName($_SESSION['project_id']);
$projectDescription = getProjectDescription($_SESSION['project_id']);
$projectId = $_SESSION['project_id'];
$files = getLastThreeUploadedFiles($_SESSION['project_id']);
$meetings = getNextThreeMeetings($_SESSION['project_id']);
$uncompletedTasks = get3UncompletedTasksFromProject($_SESSION['project_id']);
$team_members = getTeamMembers($projectId);
$forumPosts = getLastActiveForumPosts($projectId,3);

$smarty->assign('meetings',$meetings);
$smarty->assign('files',$files);
$smarty->assign('projectName',$projectName);
$smarty->assign('teamMembers', $team_members);
$smarty->assign('uncompletedTasks', $uncompletedTasks);
$smarty->assign('forumPosts',$forumPosts);
$smarty->display($BASE_DIR . 'templates/dashboard.tpl');

?>

<?php
include_once "common/footer.php";
?>

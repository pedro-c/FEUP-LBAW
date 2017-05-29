<?php
include_once "common/header.php";
include_once "../database/projects.php";
include_once "../database/files.php";
include_once "../database/users.php";
include_once "../database/meetings.php";
include_once "../database/team.php";

$projectName = getProjectName($_SESSION['project_id']);
$projectDescription = getProjectDescription($_SESSION['project_id']);
$projectId = $_SESSION['project_id'];
$files = getLastThreeUploadedFiles($_SESSION['project_id']);
$meetings = getNextThreeMeetings($_SESSION['project_id']);
$team_members = getTeamMembers($projectId);

$smarty->assign('meetings',$meetings);
$smarty->assign('files',$files);
$smarty->assign('projectName',$projectName);
$smarty->assign('teamMembers', $team_members);
$smarty->display($BASE_DIR . 'templates/dashboard.tpl');

?>

<?php
include_once "common/footer.php";
?>

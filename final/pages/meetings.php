<?php
include_once "common/header.php";
include_once($BASE_DIR .'database/meetings.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/projects.php');
include_once($BASE_DIR .'database/team.php');
include_once($BASE_DIR .'database/tasks.php');

$user_id = $_SESSION['user_id'];
$project = $_SESSION['project_id'];

if(getMemberStatus($user_id, $project))
    $meetings = getFutureMeetings($project);
else $meetings = getUserFutureMeeting($project);

$members = getProjectMembers($project, $user_id);


$smarty->assign('errors', $_SESSION['error_messages']);
$smarty->assign('members',$members);
$smarty->assign('meetings',$meetings);
$smarty->assign('project',$project);
$smarty->assign('user_aut',$user_id);
$smarty->display($BASE_DIR . 'templates/meetings.tpl');


include_once "common/footer.php";
?>
t
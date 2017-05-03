<?php
include_once "common/header.php";
include_once "../database/projects.php";

$projectName = getProjectName($_SESSION['project_id']);
$projectDescription = getProjectDescription($_SESSION['project_id']);
$smarty->assign('projectName',$projectName);
$smarty->display($BASE_DIR . 'templates/dashboard.tpl');

?>

<?php
include_once "common/footer.php";
?>



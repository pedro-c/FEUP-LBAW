<?php
include_once "common/header.php";
include_once($BASE_DIR .'database/profile.php');
include_once($BASE_DIR .'database/users.php');

$projectId=$_SESSION['project_id'];
$userId=$_SESSION['user_id'];


$user = getUserInfo($userId);

$smarty->display($BASE_DIR . 'templates/profile.tpl');

?>

<?php
include_once "common/footer.php";
?>



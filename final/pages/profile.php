<?php
include_once "common/header.php";
include_once($BASE_DIR .'database/profile.php');
include_once($BASE_DIR .'database/users.php');

$user = getUserInfo($_SESSION['user_id']);
$projects = getUserProjects($_SESSION['user_id']);
$country = getUserCountry($_SESSION['user_id']);

$smarty->assign('projects',$projects);
$smarty->assign('user', $user);
$smarty->assign('country', $country);
$smarty->display($BASE_DIR . 'templates/profile.tpl');

?>

<?php
include_once "common/footer.php";
?>



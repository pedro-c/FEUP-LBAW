<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/13/17
 * Time: 3:09 PM
 */

include_once '../../config/init.php';
include_once $BASE_DIR . 'database/forum.php';
include_once $BASE_DIR . 'pages/common/header.php';
$projectId = 1;

$posts = getProjectPosts(array($projectId));

$smarty->assign('posts',$posts);
$smarty->display($BASE_DIR . 'templates/forum/forum.tpl');

?>

<?php include_once '../common/footer.php';?>

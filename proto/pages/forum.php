<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/13/17
 * Time: 3:09 PM
 */

include_once 'common/header.php';


include_once $BASE_DIR . 'database/forum.php';
include_once $BASE_DIR . 'pages/common/header.php';

$projectId = $_SESSION['project_id'];

$posts = getProjectPosts(array($projectId));

$smarty->assign('posts',$posts);
$smarty->display($BASE_DIR . 'templates/forum/forum.tpl');


include_once 'common/footer.php';

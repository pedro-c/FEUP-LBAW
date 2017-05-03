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


$numPosts = getNumPosts(array($projectId));
$numPages = ceil($numPosts / 5);

$forumPage = 1;

if (isset($_POST['forum_page']))
    $forumPage = $_POST['forum_page'];

if($forumPage < 0)
    $forumPage = 1;

if($forumPage > $numPages)
    $forumPage = $numPages;

$smarty->assign('numPages', $numPages);
$smarty->assign('forumPage', $forumPage);
//$smarty->assign('posts', $posts);
$smarty->display($BASE_DIR . 'templates/forum/forum.tpl');

include_once 'common/footer.php';

<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/13/17
 * Time: 3:09 PM
 */
ob_start();
include_once '../config/init.php';
if(!isset($_SESSION['user_id']))
    header('Location: '. $BASE_URL . 'pages/authentication.php');
if(!isset($_SESSION['project_id']))
    header('Location: '. $BASE_URL . 'pages/profile.php');
ob_end_flush();
include_once 'common/header.php';
include_once $BASE_DIR . 'database/forum.php';
include_once $BASE_DIR . 'pages/common/header.php';

$projectId = $_SESSION['project_id'];


$numPosts = getNumPosts(array($projectId));
$numPages = ceil($numPosts / 5);
if($numPages == 0)
    $numPages = 1;

$forumPage = 1;

if (isset($_POST['forum_page']))
    $forumPage = $_POST['forum_page'];

if($forumPage <= 0)
    $forumPage = 1;

if($forumPage > $numPages)
    $forumPage = $numPages;

$smarty->assign('numPages', $numPages);
$smarty->assign('forumPage', $forumPage);
//$smarty->assign('posts', $posts);
$smarty->display($BASE_DIR . 'templates/forum/forum.tpl');

include_once 'common/footer.php';

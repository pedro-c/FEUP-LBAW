<?php
/**
 * Created by IntelliJ IDEA.
 * User: epassos
 * Date: 5/29/17
 * Time: 11:32 AM
 */
include_once '../../config/init.php';
include_once $BASE_DIR . 'database/forum.php';

if (!isset($_SESSION['user_id']) || !isset($_SESSION['project_id'])) {
    if (!isset($_SESSION['user_id']))
        echo 'No user set!';
    else echo 'No project set!';
    die(1);
}

$projectId = $_SESSION['project_id'];
$userId = $_SESSION['user_id'];
$postId = $_POST['post_id'];

if (!userOwnsPost($userId, $postId) && !isCoordinator($userId, $projectId)) {
    echo 'Operation not allowed!\n';
} else if (deletePost($postId) > 0) {
    $_SESSION['success_messages'][] = '<br>' . 'Deleted post with success';
}

header("Location: " . $BASE_URL . 'pages/forum.php');

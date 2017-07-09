<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/17/17
 * Time: 4:52 PM
 */

include_once '../../config/init.php';
include_once $BASE_DIR . 'database/forum.php';

$postId = $_POST['post_id'];
$userId = $_SESSION['user_id'];
$postContent = $_POST['content'];
$postContent = htmlspecialchars($postContent);
$post = '';

if (userOwnsPost($userId, $postId)){
    $post = editPost($postId, $postContent);
}

echo $post;

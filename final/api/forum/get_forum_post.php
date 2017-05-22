<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 5/19/17
 * Time: 5:29 PM
 */

include_once '../../config/init.php';
include_once '../../database/forum.php';

/*
 * Load the post information
 * title, username, userphoto and submission date
 * content
 * number of likes
 */

$postId = $_POST['post_id'];
$userId = $_SESSION['user_id'];
$projectId = $_SESSION['project_id'];

$output = array();
$forum_post = getPost($postId,$userId);
$photo = getPhoto($forum_post['id_creator']);
$userCanEdit = ($forum_post['id_creator'] === $forum_post['id_creator'] || isCoordinator($userId,$projectId));

$output['id'] = $forum_post['post_id'];
$output['title'] = $forum_post['title'];
$output['creation_date'] = $forum_post['creation_date'];
$output['content'] = $forum_post['content'];
$output['date_modified'] = $forum_post['date_modified'];
$output['username'] = $forum_post['username'];
$output['photo'] = $photo;
$output['num_likes'] = $forum_post['num_likes'];
$output['liked_by_user'] = $forum_post['user_liked'];
$output['user_can_edit'] = $userCanEdit;

echo json_encode($output);
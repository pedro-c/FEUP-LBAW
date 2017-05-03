<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 5/2/17
 * Time: 2:40 PM
 */

include_once '../../config/init.php';
include_once '../../database/forum.php';

$projectID = $_SESSION['project_id'];
$forumPage = $_POST['forum_page'];

$posts = getProjectPosts($projectID, $forumPage);

$count = 0;
$output = array();

foreach ($posts as $post){
    $postOutput = array();
    $userID = $post['id_creator'];
    $user = getUser($userID);
    $postOutput['submitter_photo'] = getUserPhoto($user);
    $postOutput['username'] = $user['username'];
    $postOutput['id'] = $post['id'];
    $postOutput['title'] = $post['title'];
    $postOutput['creation_date'] = $post['creation_date'];

    $output[$count] = $postOutput;
    $count++;
}

echo json_encode($output);

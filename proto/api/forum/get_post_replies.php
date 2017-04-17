<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/16/17
 * Time: 3:26 PM
 */

include_once '../../config/init.php';
include_once '../../database/forum.php';

$postID = $_POST['postID'];


$replies = getReplies($postID);

$output = array();
$count = 0;

foreach ($replies as $reply){
    $replyOutput = array();
    $user = getUser($reply['creator_id']);
    $photo = getUserPhoto($user);
    $replyOutput['id'] = $reply['id'];
    $replyOutput['content'] = $reply['content'];
    $replyOutput['creation_date'] = $reply['creation_date'];
    $replyOutput['username'] = $user['username'];
    $replyOutput['photo'] = $photo;

    $output[$count] = $replyOutput;
    $count++;
}
echo json_encode($output);
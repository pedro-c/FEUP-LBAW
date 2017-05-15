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
$userId = $_SESSION['user_id'];

$replies = getReplies($postID);

$output = array();
$count = 0;

foreach ($replies as $reply){
    $replyOutput = array();
    $replyId = $reply['id'];
    $likedByUser = userLikedReply($replyId,$userId);
    $user = getUser($reply['id_creator']);
    $photo = getUserPhoto($user);
    $replyOutput['content'] = $reply['content'];
    $replyOutput['creation_date'] = $reply['creation_date'];
    $replyOutput['username'] = $user['username'];
    $replyOutput['photo'] = $photo;
    $replyOutput['n_likes'] = $reply['n_likes'];
    $replyOutput['reply_id'] = $replyId;
    $replyOutput['liked'] = $likedByUser;

    $output[$count] = $replyOutput;
    $count++;
}
echo json_encode($output);
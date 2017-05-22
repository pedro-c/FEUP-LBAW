<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 5/6/17
 * Time: 6:13 PM
 */

include_once '../../config/init.php';
include_once '../../database/forum.php';

$userId = $_SESSION['user_id'];
$replyId = $_POST['reply_id'];

$numLikes = likeReply($replyId, $userId);

echo $numLikes;

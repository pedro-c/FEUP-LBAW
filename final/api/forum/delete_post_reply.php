<?php
/**
 * Created by IntelliJ IDEA.
 * User: epassos
 * Date: 5/29/17
 * Time: 11:32 AM
 */

include_once '../../config/init.php';
include_once $BASE_DIR . 'database/forum.php';

$projectId = $_SESSION['project_id'];
$userId = $_SESSION['user_id'];
$replyId = $_POST['reply_id'];

if (userOwnsReply($userId, $replyId) || isCoordinator($userId, $projectId)) {
    if (deleteReply($replyId) > 0)
        echo 'success';
    else echo 'Operation failed';
} else
    echo 'Operation not allowed!';

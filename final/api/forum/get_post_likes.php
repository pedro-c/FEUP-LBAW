<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 5/15/17
 * Time: 9:29 AM
 */

include_once '../../config/init.php';
include_once '../../database/forum.php';

$postId = $_POST['post_id'];

echo getNumLikesPost($postId);


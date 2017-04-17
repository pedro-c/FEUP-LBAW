<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/15/17
 * Time: 6:58 PM
 */

include_once '../../config/init.php';
include_once '../../database/forum.php';

$projectID = $_POST['projectID'];
$postID = $_POST['postID'];

echo getPostContent($projectID, $postID);

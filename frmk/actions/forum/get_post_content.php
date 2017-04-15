<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/15/17
 * Time: 6:58 PM
 */
include_once '../../config/init.php';

$projectID = $_POST['projectID'];
$postID = $_POST['postID'];

$stmt = $conn->prepare("SELECT content FROM forum_post WHERE forum_post.id = ? AND forum_post.id_project = ?");
$stmt->execute(array($postID,$projectID));

$result = $stmt->fetchAll()[0];
echo $result['content'];


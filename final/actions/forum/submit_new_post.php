<?php

include_once '../../config/init.php';
include_once $BASE_DIR . 'database/forum.php';

if(!isset($_SESSION['user_id'] ) || !isset($_SESSION['project_id'])){
    if(!isset($_SESSION['user_id']))
        echo 'No user set!';
    else echo 'No project set!';
    die(1);
}

$title = $_POST['post_title'];
$post_content = $_POST['post_content'];
$post_content = htmlspecialchars($post_content);
$id_project = $_SESSION['project_id'];
$id_user = $_SESSION['user_id'];


submitPost($id_project, $id_user, $title, $post_content);

$_SESSION['success_messages'][] = '<br>'.'Submitted post with success';
header("Location: ". $BASE_URL . "pages/forum.php");

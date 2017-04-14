<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/14/17
 * Time: 10:51 PM
 */

if(isset($_POST['action'])) {
    switch ($_POST['action']){
        case 'create-post':
            createPost();
            break;
        default:
            break;
    }
}

function select(){
    echo 'Called select function';
    exit;
}

function insert(){
    echo 'Called insert function';
    exit;
}

function getProjectPosts($projectId){
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM forum_post WHERE id_project = ? ORDER BY date_modified DESC");
    $stmt->execute($projectId);
    return $stmt->fetchAll();
}

function getPostSubmitter($userId){
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM user_table WHERE id = ?");
    $stmt->execute($userId);
    return $stmt->fetch(0);
}
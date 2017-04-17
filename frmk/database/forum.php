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

function getUser($userId){
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM user_table WHERE id = ?");
    $stmt->execute(array($userId));
    return $stmt->fetchAll()[0];
}

function getUserPhoto($user){
    global $BASE_DIR;
    if (!is_null($user['photo_path']) && file_exists($BASE_DIR. $user['photo_path'])) {
        return '../../images/users/' . $user['photo_path'];
    }
    else {
        return '../../images/assets/default_image_profile1.jpg';
    }
}

function getPostContent($projectID, $postID){
    global $conn;

    $stmt = $conn->prepare("SELECT content FROM forum_post WHERE forum_post.id = ? AND forum_post.id_project = ?");
    $stmt->execute(array($postID,$projectID));

    $result = $stmt->fetchAll()[0];
    return $result['content'];
}

function getReplies($postID){
    global $conn;

    $stmt = $conn->prepare("SELECT * FROM forum_reply WHERE forum_reply.post_ID = ? ORDER BY creation_date ASC");
    $stmt->execute(array($postID));
    $replies = $stmt->fetchAll();
    return $replies;
}

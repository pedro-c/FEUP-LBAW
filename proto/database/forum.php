<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/14/17
 * Time: 10:51 PM
 */


function select(){
    echo 'Called select function';
    exit;
}

function submit_post($id_project, $id_user, $title, $content){
    global $conn;
    $stmt = $conn->prepare("INSERT INTO forum_post (title,creation_date,content,id_project,date_modified,id_creator) VALUES (?,?,?,?,?,?)");
    $date = date("Y-m-d H:i:s");
    $result = $stmt->execute(array($title, $date, $content, $id_project, $date , $id_user));
    return $result;
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
        return '../images/users/' . $user['photo_path'];
    }
    else {
        return '../images/assets/default_image_profile1.jpg';
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

function submitPostReply($userID, $postID, $replyContent){
    global $conn;

    $date = date("Y-m-d H:i:s");
    $stmt = $conn->prepare("INSERT INTO forum_reply (creation_date, content, post_id, creator_id) VALUES (?,?,?,?)");
    $stmt->execute(array($date,$replyContent,$postID,$userID));
    $replyID = $conn->lastInsertId();
    $stmt = $conn->prepare("SELECT * FROM forum_reply WHERE forum_reply.id = ?");
    $stmt->execute(array(intval($replyID)));
    $reply = $stmt->fetchAll()[0];
    $user = getUser($reply['creator_id']);
    $username = $user['username'];
    $photo = getUserPhoto($user);
    $output = array();
    $output['id'] = $reply['id'];
    $output['creation_date'] = $reply['creation_date'];
    $output['content'] = $reply['content'];
    $output['username'] = $username;
    $output['photo'] = $photo;

    return json_encode($output);
}
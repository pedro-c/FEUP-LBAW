<?php
/**
 * Created by PhpStorm.
 * User: epassos
 * Date: 4/14/17
 * Time: 10:51 PM
 */


include_once 'common.php';

function submitPost($id_project, $id_user, $title, $content)
{
    global $conn;
    $stmt = $conn->prepare("INSERT INTO forum_post (title,creation_date,content,id_project,date_modified,id_creator) VALUES (?,?,?,?,?,?)");
    $date = date("Y-m-d H:i:s");
    $result = $stmt->execute(array($title, $date, $content, $id_project, $date, $id_user));
    return $result;
}

function getNumPosts($projectId)
{
    global $conn;
    $stmt = $conn->prepare("SELECT COUNT(*) FROM forum_post WHERE id_project = ?");
    $stmt->execute($projectId);
    return $stmt->fetch()['count'];
}

function getProjectPosts($projectId, $forumPage)
{
    global $conn;
    $offset = ($forumPage - 1) * 5;
    $stmt = $conn->prepare("SELECT * FROM forum_post WHERE id_project = ? ORDER BY date_modified DESC LIMIT 5 OFFSET ?");
    $stmt->execute(array($projectId, $offset));
    $posts = $stmt->fetchAll();
    return $posts;
}


function getPost($postId, $userId)
{
    global $conn;

    $stmt = $conn->prepare("
    SELECT forum_post.id AS post_id, title, creation_date, forum_post.content, date_modified, id_creator, username, count(forum_post_like.id_user) AS num_likes, 
    EXISTS 
    (
        SELECT * FROM forum_post_like WHERE id_post = ? AND id_user = ?
    ) AS user_liked

    FROM forum_post LEFT JOIN forum_post_like ON id = id_post, user_table
    WHERE forum_post.id = ?
    AND forum_post.id_creator = user_table.id
    GROUP BY forum_post.id,username");

    $stmt->execute(array($postId, $userId, $postId));
    return $stmt->fetchAll()[0];
}

function getPostContent($projectID, $postID)
{
    global $conn;

    $stmt = $conn->prepare("SELECT content FROM forum_post WHERE forum_post.id = ? AND forum_post.id_project = ?");
    $stmt->execute(array($postID, $projectID));

    $result = $stmt->fetchAll()[0];
    return $result['content'];
}

/**
 * Returns the id, creation date, content, replier id and number of likes of every reply of a given forum post
 *
 * @param $postID id of the forum post
 * @return array id, creation date, content, replier id and number of likes
 */
function getReplies($postID)
{
    global $conn;

    $stmt = $conn->prepare(
        "SELECT id,creation_date,content,id_creator,n_likes
        FROM 
        (
        SELECT id, creation_date,content,id_creator, count(forum_reply_like.id_user) AS n_likes
        FROM forum_reply LEFT JOIN forum_reply_like ON id = id_reply
        WHERE id_post = ?
        GROUP BY id
        ) reply_info
        ORDER BY creation_date ASC"
    );
    $stmt->execute(array($postID));
    $replies = $stmt->fetchAll();
    return $replies;
}

function submitPostReply($userID, $postID, $replyContent)
{
    global $conn;

    $date = date("Y-m-d H:i:s");
    $stmt = $conn->prepare("INSERT INTO forum_reply (creation_date, content, id_post, id_creator) VALUES (?,?,?,?)");
    $stmt->execute(array($date, $replyContent, $postID, $userID));
    $replyID = $conn->lastInsertId();
    $stmt = $conn->prepare("SELECT * FROM forum_reply WHERE forum_reply.id = ?");
    $stmt->execute(array(intval($replyID)));
    $reply = $stmt->fetchAll()[0];
    $user = getUser($reply['id_creator']);
    $username = $user['username'];
    $photo = getPhoto($userID);
    $output = array();
    $output['id'] = $reply['id'];
    $output['creation_date'] = $reply['creation_date'];
    $output['content'] = $reply['content'];
    $output['username'] = $username;
    $output['photo'] = $photo;

    return json_encode($output);
}

function likePost($postId, $userId)
{
    global $conn;

    $stmt = $conn->prepare("INSERT INTO forum_post_like(id_post,id_user) VALUES (?,?)");
    $stmt->execute(array($postId, $userId));

    return getNumLikesPost($postId);
}

function unlikePost($postId, $userId)
{
    global $conn;

    $stmt = $conn->prepare("DELETE FROM forum_post_like WHERE id_post = ? AND id_user = ?");
    $stmt->execute(array($postId, $userId));

    return getNumLikesPost($postId);
}

function likeReply($replyId, $userId)
{
    global $conn;

    $stmt = $conn->prepare("INSERT INTO forum_reply_like(id_reply,id_user) VALUES (?,?)");
    $stmt->execute(array($replyId, $userId));

    return getNumLikesReply($replyId);
}

function unlikeReply($replyId, $userId)
{
    global $conn;

    $stmt = $conn->prepare("DELETE FROM forum_reply_like WHERE id_reply = ? AND id_user = ?");
    $stmt->execute(array($replyId, $userId));

    return getNumLikesReply($replyId);
}

function getNumLikesPost($postId)
{
    global $conn;

    $stmt = $conn->prepare("SELECT COUNT(*) FROM forum_post_like WHERE id_post = ?");
    $stmt->execute(array($postId));
    return $stmt->fetch()['count'];
}

function userLikedPost($postId, $userId)
{
    global $conn;
    $stmt = $conn->prepare("SELECT EXISTS (SELECT * FROM forum_post_like WHERE id_post = ? AND id_user = ?)");
    $stmt->execute(array($postId, $userId));
    return $stmt->fetch()['exists'];
}

function getNumLikesReply($replyId)
{
    global $conn;

    $stmt = $conn->prepare("SELECT COUNT(*) FROM forum_reply_like WHERE id_reply = ?");
    $stmt->execute(array($replyId));
    return $stmt->fetch()['count'];
}


function userLikedReply($replyId, $userId)
{
    global $conn;

    $stmt = $conn->prepare("SELECT EXISTS (SELECT * FROM forum_reply_like WHERE id_reply = ? AND id_user = ?)");
    $stmt->execute(array($replyId, $userId));
    return $stmt->fetch()['exists'];
}

function editReply($replyId, $replyContent)
{
    global $conn;
    $stmt = $conn->prepare("UPDATE forum_reply
    SET content = ? WHERE id = ? RETURNING content");
    $stmt->execute(array($replyContent, $replyId));
    return $stmt->fetch()['content'];
}

function editPost($postId, $postContent)
{
    global $conn;
    $stmt = $conn->prepare("UPDATE forum_post
    SET content = ? WHERE id = ? RETURNING content");
    $stmt->execute(array($postContent,$postId));
    return $stmt->fetch()['content'];
}

function userOwnsReply($userId, $replyId)
{
    global $conn;
    $stmt = $conn->prepare("SELECT EXISTS (SELECT * FROM forum_reply WHERE id_creator = ? AND id = ?)");
    $stmt->execute(array($userId, $replyId));
    return $stmt->fetch()['exists'];
}

function userOwnsPost($userId, $postId)
{
    global $conn;
    $stmt = $conn->prepare("SELECT EXISTS (SELECT * FROM forum_post WHERE id_creator = ? AND id = ?)");
    $stmt->execute(array($userId, $postId));
    return $stmt->fetch()['exists'];
}

function deleteReply($replyId)
{
    global $conn;
    $stmt = $conn->prepare("DELETE FROM forum_reply WHERE id = ?");
    $stmt->execute(array($replyId));
    return $stmt->fetchAll();
}

function deletePost($postId)
{
    global $conn;
    $stmt = $conn->prepare("DELETE FROM forum_post WHERE id = ?");
    $stmt->execute(array($postId));
    return $stmt->fetchAll();
}

function getLastActiveForumPosts($projectId, $numPosts)
{
    global $conn;
    $stmt = $conn->prepare("SELECT username, user_table.id as creator_id, forum_post.title as title
        FROM forum_post, user_table
        WHERE forum_post.id_project = ? AND user_table.id = forum_post.id_creator
        ORDER BY date_modified DESC
        LIMIT ?");
    $stmt->execute(array($projectId,$numPosts));
    return $stmt->fetchAll();
}
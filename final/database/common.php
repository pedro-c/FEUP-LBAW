<?php
/**
 * Created by IntelliJ IDEA.
 * User: epassos
 * Date: 5/22/17
 * Time: 9:44 AM
 */

function isCoordinator($member_id, $project_id)
{

    global $conn;
    $sql_get_member_status = "SELECT is_coordinator FROM user_project, user_table
     WHERE user_table.id = ? AND user_table.id = user_project.id_user AND user_project.id_project = ?;";
    $stmt = $conn->prepare($sql_get_member_status);
    $stmt->execute(array($member_id, $project_id));
    $result = $stmt->fetch();

    return $result['is_coordinator'];
}

function getPhoto($userId)
{

    global $conn;
    $stmt = $conn->prepare('SELECT photo_path FROM user_table WHERE id = ?');
    $stmt->execute(array($userId));
    $result = $stmt->fetch(PDO::FETCH_ASSOC);


    if (!is_null($result['photo_path']) && file_exists("../images/users/" . $result['photo_path'])) {
        return '../images/users/' . $result['photo_path'];
    } else {
        return '../images/assets/default_image_profile1.jpg';
    }
}

function getUser($userId)
{
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM user_table WHERE id = ?");
    $stmt->execute(array($userId));
    return $stmt->fetchAll()[0];
}

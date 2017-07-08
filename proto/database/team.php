<?php


function getTeamMembers($project_id) {

    global $conn;
    $sql_get_project_members = "SELECT id, name, username, email, phone_number, photo_path, birth_date, country_id, city, is_coordinator
        FROM user_table, user_project
        WHERE user_project.id_user = user_table.id AND user_project.id_project = ?;";
    $stmt = $conn->prepare($sql_get_project_members);
    $stmt->execute(array($project_id));
    $project_members = $stmt->fetchAll();

    return $project_members;
}

function getTeamName($project_id) {

    global $conn;
    $sql_get_project_name = "SELECT name FROM project WHERE id = ?;";
    $stmt = $conn->prepare($sql_get_project_name);
    $stmt->execute(array($project_id));
    $project_name = $stmt->fetch();

    return $project_name['name'];
}

function removeMember($user_id, $project_id) {

    global $conn;
    $sql_remove_member = "DELETE FROM user_project WHERE id_user = ? AND id_project = ?;";
    $stmt = $conn->prepare($sql_remove_member);
    return $stmt->execute(array($user_id, $project_id));
}

function inviteMember($user_email, $project_id) {

    global $conn;
    $sql_invite_member = "INSERT INTO invited_users (id_project, email) VALUES (?, ?);";
    $stmt = $conn->prepare($sql_invite_member);
    return $stmt->execute(array($project_id, $user_email));
}
?>

<?php

function getMemberStatus($member_id, $project_id) {

    global $conn;
    $sql_get_member_status = "SELECT is_coordinator FROM user_project, user_table
     WHERE user_table.id = ? AND user_table.id = user_project.id_user AND user_project.id_project = ?;";
    $stmt = $conn->prepare($sql_get_member_status);
    $stmt->execute(array($member_id, $project_id));
    $result = $stmt->fetch();

    return $result['is_coordinator'];
}

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
    $invited_member = getInvitedMember($user_email, $project_id);
    $generated_code = generateInviteCode($user_email, $project_id);
    if($invited_member != null || $generated_code == null) {
      return null;
    }
    $sql_invite_member = "INSERT INTO invited_users (id_project, email, code) VALUES (?, ?, ?);";
    $stmt = $conn->prepare($sql_invite_member);
    return $stmt->execute(array($project_id, $user_email, $generated_code));
}

function getInvitedMember($user_email, $project_id) {

    global $conn;
    $sql_select_invited_member = "SELECT id_project, email FROM invited_users WHERE id_project = ? AND email = ?;";
    $stmt = $conn->prepare($sql_select_invited_member);
    $stmt->execute(array($project_id, $user_email));
    return $stmt->fetch();
}

function generateInviteCode($user_email, $project_id) {

    global $conn;

    $length = 10;
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $charactersLength = strlen($characters);
    $randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, $charactersLength - 1)];
    }

    $sql_select_code = "SELECT * FROM invited_users WHERE code = ?;";
    $stmt = $conn->prepare($sql_select_code);
    $stmt->execute(array($randomString));
    $a = $stmt->fetch();
    if($a != null) {
      return null;
    } else {
      return $randomString;
    }
}

function invitedUserExists($user_email, $project_id, $code) {

    global $conn;
    $sql_select_invited_member = "SELECT * FROM invited_users WHERE email = ? AND id_project = ? AND code = ?;";
    $stmt = $conn->prepare($sql_select_invited_member);
    $stmt->execute(array($user_email, $project_id, $code));
    return $stmt->fetch();
}
?>

<?php


function createNewProject($name){

    global $conn;
    $stmt = $conn->prepare('INSERT INTO project(name) VALUES (?)');
    $stmt->execute([$name]);

    $last_id = $conn->lastInsertId();

    return $last_id;
}

function getFirstUserProject($user_id){

    global $conn;
    $stmt = $conn->prepare('SELECT id_project FROM user_project WHERE id_user = ?');
    $stmt->execute([$user_id]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    $first_project = $result['id_project'];

    return $first_project;
}

function getProjectName($project_id){
    global $conn;
    $stmt = $conn->prepare('SELECT name FROM project WHERE id = ?');
    $stmt->execute([$project_id]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    return $result['name'];
}

function getProjectDescription($project_id){
    global $conn;
    $stmt = $conn->prepare('SELECT description FROM project WHERE id = ?');
    $stmt->execute([$project_id]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    return $result['description'];
}

function getProjectMembers($project, $user){
    global $conn;

    $stmt = $conn->prepare('SELECT id_user FROM user_project WHERE id_project=? AND id_user <> ? ');

    $stmt->execute([$project,$user]);
    return $stmt->fetchAll();
}

function getUserProjects($user_id){
    global $conn;
    $stmt = $conn->prepare('SELECT id_project FROM user_project WHERE id_user = ?');
    $stmt->execute([$user_id]);
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);

    return $result;
}

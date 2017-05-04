<?php

function isLoginCorrect($email, $password){

    global $conn;
    $stmt = $conn -> prepare('SELECT password FROM user_table WHERE email = ?');
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    $hashed_password = $result['password'];

    return password_verify($password,$hashed_password);
}

function createUser($name, $email, $username, $password){

    global $conn;
    $stmt = $conn->prepare('INSERT INTO user_table (name, email, username, password ) VALUES(?,?,?,?)');

    return $stmt->execute([$name, $email,$username,password_hash($password, PASSWORD_DEFAULT)]);
}

function getUserId($email){
    global $conn;
    $stmt = $conn -> prepare('SELECT id FROM user_table WHERE email = ?');
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    return $result['id'];

}

function getUsername($email){
    global $conn;
    $stmt = $conn -> prepare('SELECT username FROM user_table WHERE email = ?');
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    return $result['username'];
}

function getUserNameById($id){

    global $conn;
    $stmt = $conn -> prepare('SELECT user_table.name FROM user_table WHERE id = ?');
    $stmt->execute([$id]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    return $result['name'];
}


function checkForInvitation($email,$project){

    global $conn;

    $stmt = $conn->prepare('SELECT id_project FROM invited_users WHERE email = ?');
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    $id_project = $result['id_project'];

    return ($project==$id_project);
}

function joinProject($id, $project){

    global $conn;
    $is_coordinator = 'false';
    $stmt = $conn->prepare('INSERT INTO user_project VALUES(?,?,?)');
    return $stmt->execute([$id,$project,$is_coordinator]);
}


function getPhoto($user){


    global $conn;
    $stmt = $conn -> prepare('SELECT photo_path FROM user_table WHERE id = ?');
    $stmt->execute([$user]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);


    if (!is_null($result['photo_path']) && file_exists("../images/users/". $result['photo_path'])) {
        return '../images/users/' . $result['photo_path'];
    }
    else {
        return '../images/assets/default_image_profile1.jpg';
    }
}



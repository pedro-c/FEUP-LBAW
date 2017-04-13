<?php

function isLoginCorrect($email, $password){

    global $conn;
    $stmt = $conn -> prepare('SELECT password FROM user_table WHERE email = ?');
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);

    $hashed_password = $result['password'];

    return password_verify($password,$hashed_password);
}

function createUser($email, $username, $password){

    global $conn;
    $stmt = $conn->prepare('INSERT INTO user_table (email, username, password ) VALUES(?,?,?)');

    return $stmt->execute([$email,$username,password_hash($password, PASSWORD_DEFAULT)]);
}


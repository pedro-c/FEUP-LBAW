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


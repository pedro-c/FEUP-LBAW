<?php


function createNewProject($name){

    global $conn;
    $stmt = $conn->prepare('INSERT INTO project(name) VALUES (?)');
    $stmt->execute([$name]);

    $last_id = $conn->lastInsertId();

    return $last_id;
}
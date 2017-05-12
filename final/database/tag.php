<?php


function getAllTagNames(){
    global $conn;
    $stmt = $conn->prepare('SELECT * FROM tag');
    $stmt->execute();

    return $stmt->fetchAll();
}
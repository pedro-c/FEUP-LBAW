<?php

include_once ('init.php');

function getProjects($idUser){
    global $conn;
    $stmt = $conn->prepare('SELECT * FROM project WHERE id = ?');
    $stmt->execute([$idUser]);


    return $stmt->fetch();
}
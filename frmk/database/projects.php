<?php

function getProjects(){
    global $conn;
    $stmt = $conn->prepare("SELECT * FROM project");
    $stmt->execute();

    return $stmt->fetchAll();
}
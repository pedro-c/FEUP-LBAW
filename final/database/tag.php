<?php


function getAllTagNames(){
    global $conn;
    $stmt = $conn->prepare("SELECT DISTINCT * FROM tag, project_tag WHERE project_tag.project_id = ? AND tag.id = project_tag.tag_id;");
    $stmt->execute([$_SESSION['project_id']]);
    return $stmt->fetchAll();
}

function updateProjectTags($taskId){
    global $conn;
    $stmt = $conn->prepare("INSERT INTO project_tag (project_id, tag_id) VALUES (?,?);");
    $stmt->execute([$_SESSION['project_id'], $taskId]);
}

function addTag($tagName){
    global $conn;
    $stmt = $conn->prepare("INSERT INTO tag (id, name) VALUES (DEFAULT ,?);");
    $stmt->execute([$tagName]);
}
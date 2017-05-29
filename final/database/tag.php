<?php


function getAllTagNames(){
    global $conn;
    $stmt = $conn->prepare("SELECT DISTINCT * FROM tag, project_tag WHERE project_tag.project_id = ? AND tag.id = project_tag.tag_id;");
    $stmt->execute([$_SESSION['project_id']]);
    return $stmt->fetchAll();
}

function getAllProjectTagName($project_id){
    global $conn;
    $stmt = $conn->prepare('SELECT name,id FROM tag INNER JOIN project_tag ON tag.id = project_tag.tag_id AND project_tag.project_id = ?');

    $stmt->execute([$project_id]);
    return $stmt->fetchAll(PDO::FETCH_COLUMN, 0);
}

function existsTag($tag_name){

    global $conn;
    $stmt = $conn->prepare("SELECT id FROM tag WHERE name = ?");
    $stmt->execute([$tag_name]);
    $result = $stmt->fetch();

    if(is_null($result['id']))
        return -1;
    return $result['id'];
}


function createTag($tag_name){
    global $conn;
    $stmt = $conn->prepare('INSERT INTO tag(name) values (?)');
    $stmt->execute([$tag_name]);

    return $conn->lastInsertId();
}

function addTagToProject($project_id, $tag_id){
    global $conn;
    $stmt = $conn->prepare('INSERT INTO project_tag(project_id,tag_id) values (?,?)');
    $stmt->execute([$project_id, $tag_id]);
}
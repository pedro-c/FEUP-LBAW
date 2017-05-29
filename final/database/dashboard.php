<?php

function getFirstThreeTasks($id_project){

    global $conn;
    $stmt = $conn->prepare('SELECT name, deadline 
                            FROM task
                            WHERE deadline > CURRENT_DATE
                            AND project_id = ?
                            ORDER BY deadline ASC
                            LIMIT 3');

    $stmt->execute([$id_project]);
    return $stmt->fetchAll();
}


function getLastUploadedFiles($id_project){

    global $conn;
    $stmt = $conn->prepare('SELECT path, user_table.name, user_table.photo_path
                            FROM file, user_table WHERE user_table.id = file.uploader_id 
                            AND project_id = ?
                            ORDER BY upload_date 
                            DESC LIMIT 3');

    $stmt->execute([$id_project]);
    return $stmt->fetchAll();
}


function changeProjectName($project_name, $project_id){
    global $conn;
    $stmt = $conn->prepare('UPDATE project set name=? WHERE id=? ');
    return $stmt->execute([$project_name, $project_id]);
}
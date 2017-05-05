<?php


function addFile($date, $uploader_id, $project_id, $name){
    global $conn;
    $stmt = $conn->prepare('INSERT INTO file(upload_date, uploader_id, project_id, name) values (?,?,?,?)');
    $stmt->execute([$date, $uploader_id, $project_id, $name]);
    $last_id_meeting = $conn->lastInsertId();
    return $last_id_meeting;
}

function addFileToMeeting($file_id, $meeting_id){
    global $conn;
    $stmt = $conn->prepare('INSERT INTO file_meeting(file_id, meeting_id) values (?,?)');
    $stmt->execute([$file_id, $meeting_id]);
}


function getFilePath($file_id){
    global $conn;
    $stmt = $conn -> prepare('SELECT name FROM file WHERE id = ?');
    $stmt->execute([$file_id]);
    $filename =  $stmt->fetchAll(PDO::FETCH_COLUMN, 0);

    return $filename;
}
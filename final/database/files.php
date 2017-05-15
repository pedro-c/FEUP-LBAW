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

function getAllFiles($project_id){
    global $conn;
    $stmt = $conn->prepare('SELECT id,upload_date,uploader_id,name FROM file WHERE project_id = ? ORDER BY upload_date DESC');
    $stmt->execute([$project_id]);

    return $stmt->fetchAll();
}

function getFileDetails($file_id){
    global $conn;
    $stmt = $conn->prepare('SELECT user_table.name as uploader_name, user_table.photo_path, file.id,file.upload_date,file.uploader_id, file.project_id, file.name as file_name FROM file,user_table WHERE file.id = ? AND user_table.id = file.uploader_id');
    $stmt->execute([$file_id]);

    return $stmt->fetchAll();

}

function addTagToFile($file_id,$tag_id){
    global $conn;
    $stmt = $conn->prepare('INSERT INTO file_tag  (tag_id,file_id) values (?,?)');
    $stmt->execute([$tag_id,$file_id]);
}

function getFileTag($file_id){
    global $conn;
    $stmt = $conn -> prepare('SELECT name FROM tag INNER JOIN file_tag ON file_tag.file_id=? WHERE file_tag.tag_id = tag.id' );
    $stmt->execute([$file_id]);

    return $stmt->fetch()['name'];
}

function get_day_name($timestamp){

    if (strtotime($timestamp) >= strtotime("today"))
        return "Today";
    else if (strtotime($timestamp) >= strtotime("yesterday"))
        return "Yesterday";

    return date("Y-m-d", strtotime($timestamp));
}

function getLastThreeUploadedFiles($project_id){

    global $conn;
    $stmt = $conn->prepare('SELECT id,uploader_id, name FROM file WHERE project_id = ? ORDER BY upload_date DESC LIMIT 3;');
    $stmt->execute([$project_id]);

    return $stmt->fetchAll();
}

function deleteFile($file_id){
    global $conn;
    $stmt = $conn->prepare('DELETE FROM file WHERE id=?');
    return $stmt->execute([$file_id]);
}



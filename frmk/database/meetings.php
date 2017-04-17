<?php

function getFutureMeetings($project){
    global $conn;
    $stmt = $conn->prepare('SELECT id,name,description,id_creator,date FROM meeting WHERE meeting.date > CURRENT_DATE AND meeting.id_project = ?');

    $stmt->execute([$project]);
    return $stmt->fetchAll();
}

function scheduleMeeting($title, $description, $date, $time, $duration, $id_creator, $id_project){

    list($year, $month, $day) = explode('-', $date);
    list($hour, $minute, $second) = explode(':', $time);
    $timestamp = mktime($hour, $minute, $second, $month, $day, $year);
    $time = date('Y-m-d H:i:s',$timestamp);


    global $conn;
    $stmt = $conn->prepare('INSERT INTO meeting(name, duration, description, id_creator, id_project, date ) values (?,?,?,?,?,?)');
    $stmt->execute([$title, $duration, $description, $id_creator, $id_project,$time]);

    $last_id_meeting = $conn->lastInsertId();
    return $last_id_meeting;
}

function getTimeFromTimestamp($timestamp){
    list($date, $time) = explode(' ', $timestamp);
    list($hours, $minutes, $seconds) = explode(':', $time);
    $meetingDate = $hours.":".$minutes."h";
    return $meetingDate;
}

function getDateFromTimestamp($timestamp){
    list($date, $time) = explode(' ', $timestamp);
    return $date;
}

function getMeetingDetails($meeting_id){

    global $conn;
    $stmt = $conn->prepare('SELECT name,description,duration,id_creator,date FROM meeting WHERE meeting.id = ?');

    $stmt->execute([$meeting_id]);
    return $stmt->fetchAll();


}
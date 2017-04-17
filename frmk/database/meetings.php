<?php

function getFutureMeetings($project){
    global $conn;
    $stmt = $conn->prepare('SELECT name,description,duration,id_creator,date FROM meeting WHERE meeting.date > CURRENT_DATE AND meeting.id_project = ?');

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
    return $stmt->execute([$title, $duration, $description, $id_creator, $id_project,$time]);
}

function getTimeFromTimestamp($timestamp){
    list($date, $time) = explode(' ', $timestamp);
    return $time;
}

function getDateFromTimestamp($timestamp){
    list($date, $time) = explode(' ', $timestamp);
    return $date;
}
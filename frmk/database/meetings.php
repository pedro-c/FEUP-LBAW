<?php

function getFutureMeetings($project){
    global $conn;
    $stmt = $conn->prepare('SELECT name,date,description,duration,id_creator FROM meeting WHERE meeting.date > CURRENT_DATE AND meeting.id_project = ?');

    $stmt->execute([$project]);
    return $stmt->fetchAll();
}

function scheduleMeeting($title, $description, $date, $time, $duration, $id_creator, $id_project){

    list($hours, $minutes) = explode(':', $time);
    $dateTime = \DateTime::createFromFormat('m/d/Y', $date)->setTime($hours, $minutes);
    $timeStamp = $dateTime->getTimestamp();

    global $conn;
    $stmt = $conn->prepare('INSERT INTO meeting(name, date, duration, description, id_creator, id_project) values (?,?,?,?,?,?)');
    return $stmt->execute([$title, $timeStamp ,$duration, $description, $id_creator, $id_project ]);
}
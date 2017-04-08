<?php

function selectNextProjectMeetings($project){
    global $conn;
    $stmt = $conn->prepare('SELECT meeting.date, description, user_table.name
                            FROM meeting, user_table
                            WHERE meeting.date > CURRENT_DATE ,
                            meeting.id_project = ?
                            AND meeting.id_creator = user_table.id ');

    $stmt->execute([$project]);
    return $stmt->fetchAll();
}
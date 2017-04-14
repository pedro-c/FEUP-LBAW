<?php

    function getAllTasksFromProject($projectId){
        global $conn;
        $stmt = $conn->prepare("SELECT name FROM task
WHERE deadline > CURRENT_DATE 
AND project_id = ?
ORDER BY deadline ASC;");
        $stmt->execute($projectId);
        return $stmt->fetchAll();
    }

    function getTagFromTask($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT DISTINCT tag_id FROM task_tag
WHERE task_id = ?;");
        $stmt->execute($taskId);
        return $stmt->fetchAll();
}



?>
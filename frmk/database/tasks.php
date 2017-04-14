<?php

    function getAllTasksFromProject($projectId){
        global $conn;
        $stmt = $conn->prepare("SELECT * FROM task
WHERE deadline > CURRENT_DATE 
AND project_id = ?
ORDER BY deadline ASC;");
        $stmt->execute($projectId);
        return $stmt->fetchAll();
    }

    function getTagFromTaskId($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT DISTINCT * FROM tag, task_tag
WHERE task_id = ?
AND tag.id = task_tag.tag_id;");
        $stmt->execute($taskId);
        return $stmt->fetchAll();
}



?>
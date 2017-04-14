<?php

    if (isset($_POST['action'])) {
        switch ($_POST['action']) {
            case 'create-task':
                createTask();
                break;
            case 'complete-task':
                completeTask();
                break;
            case 'delete-task':
                deleteTask();
                break;
        }
    }

    function select() {
        echo "The select function is called.";
        exit;
    }

    function insert() {
        echo "The insert function is called.";
        exit;
    }

    function getAllTasksFromProject($projectId){
        global $conn;
        $stmt = $conn->prepare("SELECT * FROM task WHERE deadline > CURRENT_DATE AND project_id = ? ORDER BY deadline ASC;");
        $stmt->execute($projectId);
        return $stmt->fetchAll();
    }

    function getTagFromTaskId($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT DISTINCT * FROM tag, task_tag WHERE task_id = ? AND tag.id = task_tag.tag_id;");
        $stmt->execute($taskId);
        return $stmt->fetchAll();
    }

    function createTask($creator_id, $project_id){
        global $conn;
        $stmt = $conn->prepare("INSERT INTO task VALUES (DEFAULT, ?, ?, ?)");
        $stmt->execute('New Task', $creator_id, $project_id);
    }

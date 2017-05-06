<?php

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
        $stmt = $conn->prepare("SELECT * FROM task WHERE project_id = ? ORDER BY deadline ASC;");
        $stmt->execute($projectId);
        return $stmt->fetchAll();
    }

    function getTagFromTaskId($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT DISTINCT * FROM tag, task_tag WHERE task_id = ? AND tag.id = task_tag.tag_id;");
        $stmt->execute([$taskId]);
        return $stmt->fetchAll();
    }

    function createTask(){

        global $conn;
        $stmt = $conn->prepare("INSERT INTO task (id, name, description, deadline, creator_id, assigned_id, completer_id, project_id) VALUES (DEFAULT, ?, NULL, NULL, ?, NULL, NULL, ?) RETURNING id;");
        $stmt->execute(["New Task", $_SESSION['user_id'], $_SESSION['project_id']]);
        return $stmt->fetchAll();

    }

    function completeTask(){

    }

    function deleteTask($taskId){
        global $conn;
        $stmt = $conn->prepare("DELETE FROM task WHERE id = ?;");
        $stmt->execute([$taskId]);
    }

    function getTaskDetails($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT * FROM task WHERE id = ?;");
        $stmt->execute([$taskId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    function getTaskComments($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT comment.creation_date, comment.content, user_table.name, user_table.photo_path FROM comment, user_table WHERE comment.id_task = ? AND comment.id_user = user_table.id;");
        $stmt->execute([$taskId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    function getTaskName($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT name FROM task WHERE id = ?;");
        $stmt->execute([$taskId]);
        return $stmt->fetchAll();
    }

    function getTaskDescription($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT description FROM task WHERE id = ?;");
        $stmt->execute([$taskId]);
        return $stmt->fetchAll();
    }

    function getTaskDeadline($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT deadline FROM task WHERE id = ?;");
        $stmt->execute([$taskId]);
        return $stmt->fetchAll();
    }

    function getTaskCreatorName($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT name FROM user_table, task WHERE task.id = ? AND task.creator_id = user_table.id;");
        $stmt->execute([$taskId]);
        return $stmt->fetchAll();
    }

    function getTaskAssignedName($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT DISTINCT user_table.name, user_table.id FROM user_table, task WHERE task.id = ? AND task.assigned_id = user_table.id;");
        $stmt->execute([$taskId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    function getTaskCompleterName($taskId){
        global $conn;
        $stmt = $conn->prepare("SELECT name FROM user_table, task WHERE task.id = ? AND task.completer_id = user_table.id;");
        $stmt->execute([$taskId]);
        return $stmt->fetchAll();
    }

    function getProjectMembersNames($project){
        global $conn;
        $stmt = $conn->prepare('SELECT user_table.name, user_table.id FROM user_project, user_table WHERE id_project=? AND user_table.id=user_project.id_user');
        $stmt->execute([$project]);
        return $stmt->fetchAll();
    }

    function setTaskAssigned($assignedId, $taskId){
        global $conn;
        $stmt = $conn->prepare('UPDATE task SET assigned_id = ? WHERE id=?;');
        $stmt->execute([$assignedId,$taskId]);
    }

    function setTaskName($name, $taskId){
        global $conn;
        $stmt = $conn->prepare('UPDATE task SET name = ? WHERE id=?;');
        $stmt->execute([$name,$taskId]);
    }

    function setTaskDescription($description, $taskId){
        global $conn;
        $stmt = $conn->prepare('UPDATE task SET description = ? WHERE id=?;');
        $stmt->execute([$description,$taskId]);
    }

    function setTaskDeadline($deadline, $taskId){
        global $conn;
        $stmt = $conn->prepare('UPDATE task SET deadline = ? WHERE id=?;');
        $stmt->execute([$deadline,$taskId]);
    }

    function deleteTaskTags($taskId){
        global $conn;
        $stmt = $conn->prepare("DELETE FROM task_tag WHERE task_id = ?;");
        $stmt->execute([$taskId]);
    }

    function addTaskTag($tag, $taskId){
        global $conn;
        $stmt = $conn->prepare("INSERT INTO task_tag (task_id, tag_id) VALUES (?,?);");
        $stmt->execute([$tag, $taskId]);
    }

    function addTaskComment($comment, $taskId){
        global $conn;
        $stmt = $conn->prepare("INSERT INTO comment (id, creation_date, content, id_user, id_task) VALUES (DEFAULT,LOCALTIMESTAMP,?,?,?);");
        $stmt->execute([$comment, $_SESSION['user_id'],$taskId]);
    }
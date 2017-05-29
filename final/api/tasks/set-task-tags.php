<?php
include_once('../../config/init.php');
include_once('../../database/tag.php');
include_once('../../database/tasks.php');


if (isset($_POST['taskTag'])) {
    if (isset($_POST['taskId'])) {

        $taskId = htmlspecialchars($_POST['taskId']);
        $taskTag= htmlspecialchars($_POST['taskTag']);
        if (isset($taskTag)) {
            $tag = existsTag($taskTag);

            if ($tag != -1)
                $tagId = $tag;
            else {
                $tagId = createTag($taskTag);
                addTagToProject(htmlspecialchars($_SESSION['project_id']), htmlspecialchars($tagId));
            }
            deleteTaskTags($taskId);
            print json_encode(addTaskTag($tagId,$taskId));
        }
    }
}
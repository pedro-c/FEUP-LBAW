<?php
include_once('../../config/init.php');
include_once('../../database/tag.php');
include_once('../../database/tasks.php');


if (isset($_POST['taskTag'])) {
    if (isset($_POST['taskId'])) {

        $taskId = $_POST['taskId'];
        if (isset($_POST['taskTag'])) {
            $tag = existsTag($_POST['taskTag']);

            if ($tag != -1)
                $tagId = $tag;
            else {
                $tagId = createTag($_POST['taskTag']);
                addTagToProject($_SESSION['project_id'], $tagId);
            }

            print json_encode(addTaskTag($tagId,$taskId));
        }
    }
}
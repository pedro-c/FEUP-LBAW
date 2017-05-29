<?php

include_once('../../database/files.php');
include_once('../../database/tag.php');
include_once('../../config/init.php');


if(!empty($_FILES['file'])){

    $total = count($_FILES['file']['name']);

    for($i=0; $i<$total; $i++) {
        echo $_FILES['file']['name'][$i];

        if ($_FILES['file']['tmp_name'][$i] != "") {
            $path = $BASE_DIR.'images/files/';
            $location = $path . $_FILES['file']['name'][$i];

            if (move_uploaded_file($_FILES['file']['tmp_name'][$i], $location)) {
                $_SESSION['success_messages'][] = '<br>'.'Uploaded File';
            }
            $_SESSION['success_messages'][] = '<br>'.'Error on uploading File';
        }
        $current_date = date('m/d/Y h:i:s a', time());
        $file = addFile($current_date, $_SESSION['user_id'],$_SESSION['project_id'], $_FILES['file']['name'][$i]);


        if (isset($_POST['tagOption'])) {
            $tag = existsTag($_POST['tagOption']);

            if ($tag != -1)
                $tagId = $tag;
            else {
                $tagId = createTag($_POST['tagOption']);
                addTagToProject($_SESSION['project_id'], $tagId);
            }

            addTagToFile($file,$tagId);
        }
    }

    $_SESSION['success_messages'][] = '<br>'.'Uploaded Files with success';
    header('Location: ' . $_SERVER['HTTP_REFERER']);
}




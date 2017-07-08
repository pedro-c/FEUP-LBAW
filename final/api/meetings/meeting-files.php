<?php

include_once "../../database/meetings.php";
include_once "../../database/files.php";
include_once "../../config/init.php";

if(isset($_POST['meeting_id'])){

    $meeting_files = getMeetingFiles($_POST['meeting_id']);
    print json_encode($meeting_files);
}

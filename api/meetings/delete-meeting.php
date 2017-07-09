<?php

include_once "../../database/meetings.php";
include_once "../../config/init.php";

if(isset($_POST['meeting_id'])){
   $return = deleteMeeting($_POST['meeting_id']);
    print json_encode($return);
}
<?php

include_once "../../database/meetings.php";
include_once "../../config/init.php";

if(isset($_POST['meeting_id'])){

    $meetings_attendees = getInvitedUsersPhotos($_POST['meeting_id']);
    print json_encode($meetings_attendees);
}

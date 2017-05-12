<?php

include_once('../../database/meetings.php');
include_once('../../config/init.php');

if(isset($_POST['meeting_id']) && isset($_POST['uninvited_users'])){
    inviteListUsersToMeeting($_POST['meeting_id'],$_POST['uninvited_users']);
    $_SESSION['success_messages'][] = '<br>'.'Invited Users with success';
    header('Location: ' . $_SERVER['HTTP_REFERER']);
}
else{
    $_SESSION['success_messages'][] = '<br>'.'Error inviting users to meeting';
    header('Location: ' . $_SERVER['HTTP_REFERER']);
}
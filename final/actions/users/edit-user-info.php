<?php
include_once('../../config/init.php');
include_once('../../database/users.php');

if(isset($_SESSION['user_id'])){
    $userName = $_POST['userName'];
    $userEmail = $_POST['userEmail'];
    $userCountry = $_POST['userCountry'];
    $userCity = $_POST['userCity'];


    update_user_info($userName, $userEmail, $userCountry, $userCity);
}



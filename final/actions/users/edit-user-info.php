<?php
include_once('../../config/init.php');
include_once('../../database/users.php');

if(isset($_SESSION['user_id'] )){
    $userId = $_SESSION['user_id'];
    $userName = $_POST['$userName'];
    $userEmail = $_POST['userEmail'];
    $userCountry = $_POST['userCountry'];
    $userCity = $_POST['userCity'];


    update_user_info($userId, $userName, $userEmail, $userCountry, $userCity);
    header("Location: ". $BASE_URL . "pages/profile.php");
}


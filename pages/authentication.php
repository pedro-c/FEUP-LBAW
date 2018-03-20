<?php
include_once './config/init.php';

if(isset($_SESSION['user_id'] )){
    header("Location: ". $BASE_URL . "pages/dashboard.php");
}

$smarty->display($BASE_DIR . 'templates/authentication/authentication.tpl');

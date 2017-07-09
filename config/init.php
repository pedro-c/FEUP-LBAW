<?php
session_set_cookie_params(0 ,'/~up201403820'); //session_set_cookie_params(3600, '/');
session_start();

error_reporting(E_ERROR | E_WARNING); // E_NOTICE by default

$BASE_DIR = '/';
$BASE_URL = '/'; //'/final/';

$conn = new PDO('pgsql:host=ec2-54-228-235-185.eu-west-1.compute.amazonaws.com;dbname=d644nnjg8qdhki', 'wwsobtwkkeflwe', '43d65b605514ded279487770a79c0ea1ba5a9d589c5aea337a9b31bff300f27e');
$conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$conn->exec('SET SCHEMA \'final\''); //FIXME?

include_once($BASE_DIR . 'lib/smarty/Smarty.class.php');

$smarty = new Smarty;
$smarty->template_dir = $BASE_DIR . 'templates/';
$smarty->compile_dir = $BASE_DIR . 'templates_c/';
$smarty->assign('BASE_URL', $BASE_URL);

$smarty->assign('ERROR_MESSAGES', $_SESSION['error_messages']);
$smarty->assign('FIELD_ERRORS', $_SESSION['field_errors']);
$smarty->assign('SUCCESS_MESSAGES', $_SESSION['success_messages']);
$smarty->assign('FORM_VALUES', $_SESSION['form_values']);
$smarty->assign('USERNAME', $_SESSION['username']);
$smarty->assign('EMAIL', $_SESSION['email']);
$smarty->assign('PROJECT_ID', $_SESSION['project_id']);
$smarty->assign('USER_ID', $_SESSION['user_id']);

unset($_SESSION['success_messages']);
unset($_SESSION['error_messages']);
unset($_SESSION['field_errors']);
unset($_SESSION['form_values']);
?>

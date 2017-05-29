<?php
include_once('../../config/init.php');
include_once('../../database/users.php');

if (!$_POST['old-password'] || !$_SESSION['user_id'] || !$_POST['new-password'] || !$_POST['repeat-password']) {
    $_SESSION['error_messages'][] = '<br>'.'User not logged in';
    header("Location:".$_SERVER['HTTP_REFERER']);
    exit;
}

$old_password = $_POST['old-password'];
$new_password = $_POST['new-password'];
$repeat_password = $_POST['repeat-password'];


if(!password_verify($new_password, password_hash($repeat_password, PASSWORD_DEFAULT))){
    $_SESSION['error_messages'][2] = '<br>'.'Passwords dont match';
    header('Location: ' . $_SERVER['HTTP_REFERER']);
    exit;
}

if(isPasswordCorrect($new_password)){
    $_SESSION['error_messages'][2] = '<br>'.'New password must be different from old password';
    header('Location: ' . $_SERVER['HTTP_REFERER']);
    exit;
}



try{
    if(!isPasswordCorrect($old_password)){
        $_SESSION['error_messages'][0] = '<br>'.'Old password not correct';
        header('Location: ' . $_SERVER['HTTP_REFERER']);
        exit;
    }

}
catch (PDOException $e){
    $_SESSION['error_messages'][0] = '<br>'.'Error checking password';

    $_SESSION['form_values'] = $_POST;
    header('Location: ' . $_SERVER['HTTP_REFERER']);
    exit;
};

try{
    changePassword(password_hash($new_password, PASSWORD_DEFAULT));
}
catch (PDOException $e){
    $_SESSION['error_messages'][2] = '<br>'.'Error changing password';

    $_SESSION['form_values'] = $_POST;
    header('Location: ' . $_SERVER['HTTP_REFERER']);
    exit;
};

$_SESSION['success_messages'][2] = '<br>'.'Password change successfully';


header('Location: ../../pages/profile.php');

?>

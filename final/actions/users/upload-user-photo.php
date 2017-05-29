<?php

include_once('../../database/users.php');
include_once('../../config/init.php');

$target_dir = $BASE_DIR.'images/users/';
$target_file = $target_dir . basename($_FILES["file"]["name"]);
$uploadOk = 1;
$imageFileType = pathinfo($target_file)['extension'];

// Check if image file is a actual image or fake image
if(isset($_POST["submit"])) {
    $check = getimagesize($_FILES["file"]["tmp_name"]);
    if($check !== false) {
        echo "File is an image - " . $check["mime"] . ".";
        $uploadOk = 1;
    } else {
        $_SESSION['error_messages'][] = '<br>'.'File is not an image';
        $uploadOk = 0;
    }
}
// Check file size
if ($_FILES["file"]["size"] > 500000) {
    $_SESSION['error_messages'][] = '<br>'.'File is too large';
    $uploadOk = 0;
}
// Allow certain file formats
if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg" && $imageFileType != "PNG") {
    $_SESSION['error_messages'][] = '<br>'.'Sorry, only JPG, JPEG, PNG files are allowed.'.'Uploaded type: '.$imageFileType;
    $uploadOk = 0;
}
// Check if $uploadOk is set to 0 by an error
if ($uploadOk == 0) {
    $_SESSION['error_messages'][] = '<br>'.'Error uploading file.';
    header('Location: ' . $_SERVER['HTTP_REFERER']);
} else {
    $userEmail = getUserEmail()['email'].'.'.$imageFileType;
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_dir.$userEmail)) {
        updateUserPhoto($userEmail);
        header('Location: ' . $_SERVER['HTTP_REFERER']);
    } else {
        $_SESSION['error_messages'][] = '<br>'.'Error moving file.';
        header('Location: ' . $_SERVER['HTTP_REFERER']);
    }
}


?>


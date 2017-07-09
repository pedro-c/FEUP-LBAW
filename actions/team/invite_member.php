<?php
include_once('../../config/init.php');
include_once $BASE_DIR . 'database/team.php';
?>

<?php
$project_id = $_POST['idProject'];
$user_email = $_POST['userEmail'];

$insert_result = inviteMember($user_email, $project_id); //TODO When email already exists, sends error

if($insert_result == null) {
    $jsonObject = array(
      'insert_result' => $insert_result,
      'send_result' => FALSE,
      'code' => null
    );
    echo json_encode($jsonObject);
    exit();
}

//TODO SEND EMAIL. Still sends error
//Start sasl: sudo /etc/init.d/saslauthd start
$subject = "Invite to Project";
$message = "You have been invited to a project";
$headers = "From: direkt@fe.up.pt";
$send_result = mail($user_email, $subject, $message, $headers);

$jsonObject = array(
  'insert_result' => $insert_result,
  'send_result' => $send_result,
  'code' => $insert_result
);

echo json_encode($jsonObject);
//echo $jsonObject;
//header('Location: ' . $_SERVER['HTTP_REFERER']);
 ?>

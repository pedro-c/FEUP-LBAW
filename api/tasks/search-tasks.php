<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if(isset($_POST['searchTaskText'])) {
  $searchTaskText = htmlspecialchars($_POST['searchTaskText']);

  if($searchTaskText == ''){
      $searchResultIds=getAllTasksFromProject($_SESSION['project_id']);
  }else{
      $searchResultIds = fullTextSearchTask($searchTaskText, $_SESSION['project_id']);
  }
  $resultArray = array();


  for($i = 0; $i < count($searchResultIds); $i++){
    $taskDetails = null;
    $taskTags = null;

    $taskDetails = getTaskDetails($searchResultIds[$i]['id']);
    $taskTags = getTagFromTaskId($searchResultIds[$i]['id']);

    array_push($resultArray, [$taskDetails, $taskTags]);
  }

  echo json_encode($resultArray);
}
?>

<?php
include_once('../../config/init.php');
include_once('../../database/tasks.php');

if(isset($_POST['searchTaskText'])) {
  $searchTaskText = htmlspecialchars($_POST['searchTaskText']);

  $searchResultIds = fullTextSearchTask($searchTaskText, $_SESSION['project_id']);
  $resultArray = array();


  for($i = 0; $i < count($searchResultIds); $i++){
    $taskDetails = null;
    $taskTags = null;
    $taskAssignedName = null;
    $projectMembers = null;
    $taskComments = null;
    $projectTags = null;




    $taskDetails = getTaskDetails($searchResultIds[$i]['id']);
    $taskTags = getTagFromTaskId($searchResultIds[$i]['id']);
    $taskAssignedName = getTaskAssignedName($searchResultIds[$i]['id']);
    $projectMembers = getProjectMembersNames($_SESSION['project_id']);
    $taskComments = getTaskComments($searchResultIds[$i]['id']);
    $projectTags = getTagsFromProject();

    array_push($resultArray, [$taskDetails, $taskTags, $taskAssignedName, $projectMembers, $taskComments, $projectTags]);
  }

  echo json_encode($resultArray);
}
?>

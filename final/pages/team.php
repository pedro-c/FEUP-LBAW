<?php
ob_start();
include_once "../config/init.php";
include_once "common/header.php";
include_once "../database/team.php";
?>

<link href="../css/UI6.css" rel="stylesheet">
<script src="../javascript/ui6.js"></script>

<?php
if(!isset($_SESSION['user_id'])) {
    header('Location: '. $BASE_URL . 'pages/authentication.php');
    exit();
  }
if(!isset($_SESSION['project_id'])) {
    header('Location: '. $BASE_URL . 'pages/profile.php');
    exit();
  }
ob_end_flush();

$project_id = $_SESSION['project_id'];
$user_id = $_SESSION['user_id'];

$is_coordinator = isCoordinator($user_id, $project_id);
$project_members = getTeamMembers($project_id);
$project_name = getTeamName($project_id);


//$is_coordinator = true; //TODO Set this variable according to session parameters
$num_elems = count($project_members);
if($is_coordinator) { //Adds the "Add new member" panel
  $num_elems++;
}

$elems_per_row = 3;

$num_rows = ceil($num_elems / $elems_per_row);
$col_division = 12 / $elems_per_row; //DONT CHANGE. Used for grid position purposes
?>

<div id="page-wrapper">
    <div class="container">
      <div class="panel panel-default" id="title_team_name">
        <div class="panel-body">
          <h2><?php echo $project_name; ?></h2>
        </div>
      </div>
        <?php for($i = 0; $i < $num_rows; $i++) {?>
        <div class="row">
            <?php for($j = 0; $j < $elems_per_row && $num_elems > 0; $j++, $num_elems--) {
              $actual_elem = $i*$elems_per_row + $j;
            ?>
            <div class="col-md-<?php echo $col_division; ?>">
                <?php if($is_coordinator && $num_elems == 1) {
                  $smarty->display("team/add_member_card.tpl");
                } else {
                  $team_member_title = "Team Member";
                  $is_self = FALSE;
                  if($project_members[$actual_elem]['is_coordinator']) {
                    $team_member_title = "Team Coordinator";
                  }

                  if($project_members[$actual_elem]['id'] == $user_id) {
                    $is_self = TRUE;
                  }

                  $smarty->assign('coordinator_permissions', $is_coordinator);
                  $smarty->assign('is_self', $is_self);
                  $smarty->assign('profile_name', $project_members[$actual_elem]['name']);
                  $smarty->assign('team_role', $team_member_title);
                  $smarty->assign('element_number', $num_elems);
                  $smarty->assign('city', $project_members[$actual_elem]['city']);
                  $smarty->assign('country', "Portugal"); //TODO QUERY to get this
                  $smarty->assign('profile_email', $project_members[$actual_elem]['email']);
                  $smarty->assign('profile_number', $project_members[$actual_elem]['phone_number']);
                  $smarty->assign('profile_id', $project_members[$actual_elem]['id']);
                  $smarty->assign('profile_image_path', $project_members[$actual_elem]['photo_path']); //TODO user must define what is his photo

                  $smarty->display("team/profile_card.tpl");
                } ?>
            </div>
            <?php } ?>
        </div>
        <?php } ?>

    </div>
</div>

<!-- Add a Member Modal Definition -->
<?php
$smarty->assign('project_id', $project_id);
$smarty->display("team/modals/add_member_modal.tpl");
?>

<!-- Confirmation of User Delete-->
<?php
$smarty->assign('project_id', $project_id);
$smarty->display("team/modals/remove_member_modal.tpl");
?>


<!-- Confirmation of User Promotion-->
<?php
$smarty->assign('project_id', $project_id);
$smarty->display("team/modals/promote_member_modal.tpl");
?>

<!-- Confirmation of User Depromotion-->
<?php $smarty->display("team/modals/demote_member_modal.tpl"); ?>
<?php
include_once "common/footer.html";
?>

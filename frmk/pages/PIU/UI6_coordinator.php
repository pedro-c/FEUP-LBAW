<?php
include_once "common/header.php";
include_once "../config/init.php";
?>

<link href="../../css/UI6.css" rel="stylesheet">
<script src="../../javascript/ui6.js"></script>

<?php
//TODO THESE ARE TEST VALUES
$project_id = 1;
$_SESSION['email'] = 'ccastillo5@yellowpages.com';
//$_SESSION['email'] = 'mjmp@feup.pt';

$sql_get_member_status =
"SELECT is_coordinator
FROM user_project, user_table
WHERE ? LIKE user_table.email AND user_table.id = user_project.id_user AND user_project.id_project = ?;";

$sql_get_project_members =
"SELECT id, name, username, email, phone_number, photo_path, birth_date, country_id, city, is_coordinator
FROM user_table, user_project
WHERE user_project.id_user = user_table.id AND user_project.id_project = ?;";

$sql_get_project_name =
"SELECT name
FROM project
WHERE id = ?;";

$stmt = $conn->prepare($sql_get_member_status);
$stmt->execute(array($_SESSION['email'], $project_id));
$is_coordinator = $stmt->fetch()['is_coordinator'];

$stmt = $conn->prepare($sql_get_project_members);
$stmt->execute(array($project_id));
$project_members = $stmt->fetchAll();

$stmt = $conn->prepare($sql_get_project_name);
$stmt->execute(array($project_id));
$project_name = $stmt->fetch();

//END of Alterations
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
          <h2><?php echo reset($project_name)?></h2>
        </div>
      </div>
        <?php for($i = 0; $i < $num_rows; $i++) {?>
        <div class="row">
            <?php for($j = 0; $j < $elems_per_row && $num_elems > 0; $j++, $num_elems--) {
            ?>
            <div class="col-md-<?php echo $col_division; ?>">
                <?php if($is_coordinator && $num_elems == 1) {
                  $smarty->display("team/add_member_card.tpl");
                } else {
                  $team_member_title = "Team Member";
                  $is_self = FALSE;
                  if($project_members[$j]['is_coordinator']) {
                    $team_member_title = "Team Coordinator";
                  }

                  if($project_members[$j]['email'] == $_SESSION['email']) {
                    $is_self = TRUE;
                  }

                  $smarty->assign('coordinator_permissions', $is_coordinator);
                  $smarty->assign('is_self', $is_self);
                  $smarty->assign('profile_name', $project_members[$j]['name']);
                  $smarty->assign('team_role', $team_member_title);
                  $smarty->assign('element_number', $num_elems);
                  $smarty->assign('city', $project_members[$j]['city']);
                  $smarty->assign('country', "Portugal"); //TODO QUERY to get this
                  $smarty->assign('profile_email', $project_members[$j]['email']);
                  $smarty->assign('profile_number', $project_members[$j]['phone_number']);
                  $smarty->assign('profile_id', $project_members[$j]['id']);
                  $smarty->assign('profile_image_path', "/users/".$project_members[$j]['photo_path']); //TODO user must define what is his photo

                  $smarty->display("team/profile_card.tpl");
                } ?>
            </div>
            <?php } ?>
        </div>
        <?php } ?>

    </div>
</div>

<!-- Add a Member Modal Definition -->
<div id="add_member_dialog" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Add a new member</h4>
      </div>
      <div class="modal-body">
        <p>By clicking "Send", we will be delivering a message with a password to the email below. After registration, the new member
          will have a menu where he can insert that password. When he submits it, you will have a new member on your team!</p>
        <div class="form-group">
          <label for="email_form">Email:</label>
          <input type="email" class="form-control" id="email_form">
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" id="accept_button">Send</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel_button">Close</button>
      </div>
    </div>

  </div>
</div>

<!-- Confirmation of User Delete-->
<div id="remove_member_dialog" class="modal fade" role="dialog">
  <div class="modal-dialog modal-sm">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Remove user from project</h4>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to remove this member from the project?</p>
      </div>
      <div class="modal-footer">
        <form action="../../actions/team/delete-member.php" method="post">
          <!-- TODO Use JS to insert the user id in the form, when the button is clicked -->
          <input type="hidden" name="project_id" value=<?php echo $project_id; ?> />
          <input type="hidden" name="user_id" value="0" />
          <button type="submit" class="btn btn-default" id="accept_button">Yes</button>
          <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel_button">No</button>
        </form>
      </div>
    </div>

  </div>
</div>

<!-- Confirmation of User Promotion-->
<div id="promote_member_dialog" class="modal fade" role="dialog">
  <div class="modal-dialog modal-sm">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Promote member in project</h4>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to promote this member to project coordinator?</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" id="accept_button">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel_button">No</button>
      </div>
    </div>

  </div>
</div>

<!-- Confirmation of User Depromotion-->
<div id="demote_member_dialog" class="modal fade" role="dialog">
  <div class="modal-dialog modal-sm">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Remove Coordinator privileges</h4>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to remove the privileges of this team coordinator? He will become a normal team member.</p>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" id="accept_button">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel_button">No</button>
      </div>
    </div>

  </div>
</div>

<?php
include_once "common/footer.html";
/* <div class="row">
                            <div class="col-md-6">
                                <img style="min-height: 200px;" src="../default_image_profile<?php echo (($i*($col_division-1) + $j + 1) % 2 + 1)?>.jpg" class="img-responsive" alt="Profile Photo">
                            </div>
                            <div class="col-md-6">
                                <div class="row">
                                    <h2 class="lead">Nome Genérico</h2>
                                </div>
                                <div class="row">
                                    <small>Team Coordinator</small>
                                </div>
                            </div>
                        </div>*/

/* TODO PROFILE DETAILS HTML
<div class="profile_details">
  <div class="row">
    <div class="col-md-1">
    </div>
    <div class="col-md-5" align="center">
     <p>From:</p>
    </div>
    <div class="col-md-5">
      <p>Porto, Portugal</p>
    </div>
    <div class="col-md-1">
    </div>
  </div>
  <div class="row">
    <div class="col-md-1">
    </div>
    <div class="col-md-5" align="center">
     <p>Email:</p>
    </div>
    <div class="col-md-5">
      <p>jczelik@gmail.com</p>
    </div>
    <div class="col-md-1">
    </div>
  </div>
  <div class="row">
    <div class="col-md-1">
    </div>
    <div class="col-md-5" align="center">
     <p>Phone:</p>
    </div>
    <div class="col-md-5">
      <p>999-999-999</p>
    </div>
    <div class="col-md-1">
    </div>
  </div>
  <div class="row">
    <div class="col-md-1">
    </div>
    <div class="col-md-5" align="center">
     <p>Profile:</p>
    </div>
    <div class="col-md-5">
      <a>direkt.com/user1</a>
    </div>
    <div class="col-md-1">
    </div>
  </div>
  <div class="col-md-12">
    <i class="fa fa-search-minus fa-2x"></i>
  </div>
</div>
*/
?>

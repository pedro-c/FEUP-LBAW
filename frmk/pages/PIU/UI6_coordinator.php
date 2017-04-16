<?php
include_once "common/header.php";
?>

<link href="../../css/UI6.css" rel="stylesheet">
<script src="../../javascript/ui6.js"></script>

<?php
// ---- INIT
ini_set("display_errors", true); error_reporting(E_ALL);
$conn = new PDO('pgsql:host=dbm.fe.up.pt;dbname=lbaw1614', 'lbaw1614', 'yz54fi76');
$conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$conn->exec('SET SCHEMA \'public\''); //FIXME?

$BASE_DIR = '/home/jczelik/Documents/LBAW/FEUP-LBAW/frmk/';
$BASE_URL = '/proto/';
include_once($BASE_DIR . 'lib/smarty/Smarty.class.php');
$smarty = new Smarty;
$smarty->template_dir = $BASE_DIR . 'templates/';
$smarty->compile_dir = $BASE_DIR . 'templates_c/';
$smarty->setCompileDir($BASE_DIR . 'templates_c/');
$smarty->assign('BASE_URL', $BASE_URL);
// ---- END INIT

$sql_get_project_members =
"SELECT name, username, email, phone_number, photo_path, birth_date, country_id, city, is_coordinator
FROM user_table, user_project
WHERE user_project.id_user = user_table.id AND user_project.id_project = 1;";

$sql_get_project_name =
"SELECT name
FROM project
WHERE id = 1;";

$stmt = $conn->prepare($sql_get_project_members);
$stmt->execute();
$project_members = $stmt->fetchAll();

$stmt = $conn->prepare($sql_get_project_name);
$stmt->execute();
$project_name = $stmt->fetch();

//END of Alterations
$is_coordinator = true;
$num_elems = 6;
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
                  $smarty->assign('profile_name', "José Carlos Coutinho");
                  $smarty->assign('team_role', "Team Manager");
                  $smarty->assign('element_number', $num_elems);
                  $smarty->assign('city', "Porto");
                  $smarty->assign('country', "Portugal");
                  $smarty->assign('profile_email', "jczelik@gmail.com");
                  $smarty->assign('profile_number', "913146206");
                  $smarty->assign('profile_id', "1123");
                  $smarty->assign('profile_image_path', "users/avatar1.png");

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
        <button type="button" class="btn btn-default">Send</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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
        <button type="button" class="btn btn-default" id="remove_member_button">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" id="no_remove_member_button">No</button>
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

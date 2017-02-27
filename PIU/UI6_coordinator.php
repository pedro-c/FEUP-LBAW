<?php
include_once "common/header.html";
?>

<link href="../css/UI6.css" rel="stylesheet">
<script src="../jquery-3.1.1.min.js"></script>
<script src="../js/ui6.js"></script>

<?php
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
          <h2>Team Name</h2>
        </div>
      </div>
        <?php for($i = 0; $i < $num_rows; $i++) {?>
        <div class="row">
            <?php for($j = 0; $j < $elems_per_row && $num_elems > 0; $j++, $num_elems--) {?>
            <div class="col-md-<?php echo $col_division; ?>">
                <div class="panel panel-default" id=<?php if($is_coordinator && $num_elems == 1) {
                  echo "add_member_card";
                } else {
                  echo "profile_card";
                } ?>>
                    <div class="panel-body">
                      <?php if($num_elems > 1 || !$is_coordinator) { ?>
                       <div class="media">
                            <div class="media-left media-middle" id="profile_pic">
                                <img style="width: 100px;" src="../assets/default_image_profile1.jpg" class="media-object" alt="Profile Photo">
                            </div>
                            <div class="media-body">
                                <h4 class="media-heading">José Carlos Milheiro Soares Coutinho</h4>
                                <h5 id="team_role">Team Manager</h5>
                                <i class="fa fa-search-plus fa-2x" data-toggle="collapse" data-target="#profile_details<?php echo $num_elems;?>"></i>
                            </div>
                       </div>
                       <div id="profile_details<?php echo $num_elems;?>" class="collapse">
                         <div class="profile_details">
                           <div class="row">
                             <div class="col-xs-1">
                             </div>
                             <div class="col-xs-5" align="center">
                              <p>From:</p>
                             </div>
                             <div class="col-xs-5">
                               <p>Porto, Portugal</p>
                             </div>
                             <div class="col-xs-1">
                             </div>
                           </div>
                           <div class="row">
                             <div class="col-xs-1"></div>
                             <div class="col-xs-5" align="center">
                              <p>Email:</p>
                             </div>
                             <div class="col-xs-5">
                               <p>jczelik@gmail.com</p>
                             </div>
                             <div class="col-xs-1"></div>
                           </div>
                           <div class="row">
                             <div class="col-xs-1"></div>
                             <div class="col-xs-5" align="center">
                              <p>Phone:</p>
                             </div>
                             <div class="col-xs-5">
                               <p>999-999-999</p>
                             </div>
                             <div class="col-xs-1"></div>
                           </div>
                           <div class="row">
                             <div class="col-xs-1"></div>
                             <div class="col-xs-5" align="center">
                              <p>Profile:</p>
                             </div>
                             <div class="col-xs-5">
                               <a>direkt.com/user1</a>
                             </div>
                             <div class="col-xs-1"></div>
                           </div>
                           <div class="row" id="profile_actions">
                             <div class="col-xs-3"></div>
                             <div class="col-xs-3" align="center">
                              <i class="fa fa-star fa-3x" id="promote<?php echo $num_elems;?>"></i>
                             </div>
                             <div class="col-xs-3" align="center">
                               <i class="fa fa-times fa-3x" id="remove<?php echo $num_elems;?>"></i>
                             </div>
                             <div class="col-xs-3"></div>
                           </div>
                           <div class="col-xs-12" id="zoom_out_action">
                             <i class="fa fa-search-minus fa-2x" data-toggle="collapse" data-target="#profile_details<?php echo $num_elems;?>" id="zoom_out"></i>
                           </div>
                         </div>
                       </div>
                      <?php } else { ?>
                        <div data-toggle="modal" data-target="#add_member_dialog">
                          <div class="row" id="add_member" align="center">
                            <div class="col-md-12">
                              <i class="fa fa-plus-circle fa-4x"></i>
                            </div>
                          </div>
                          <div class="row" align="center">
                            <div class="col-md-12">
                              <h3>Add a new member!</h3>
                            </div>
                          </div>
                        </div>
                      <?php } ?>
                    </div>
                </div>
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

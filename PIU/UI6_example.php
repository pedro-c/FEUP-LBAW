<?php
include_once "common/header.php";
?>

<link href="../../css/UI6.css" rel="stylesheet">
<script src="../../javascript/ui6.js"></script>

<?php
$is_coordinator = true;
$num_elems = 6;
if($is_coordinator) { //Adds the "Add new member" panel
  $num_elems++;
}

$elems_per_row = 3;

$num_rows = ceil($num_elems / $elems_per_row);
$col_division = 12 / $elems_per_row; //DONT CHANGE. Used for grid position purposes


$col1 = 1;
$col2 = 5;
$col3 = 5;
$col4 = 1;
?>

<div id="page-wrapper">
    <div class="container">
      <div class="panel panel-default" id="title_team_name">
        <div class="panel-body">
          <h2>Team Name</h2>
        </div>
      </div>
        <div class="row">
            <div class="col-md-4">
                <div class="panel panel-default" id="profile_card">
                    <div class="panel-body">
                       <div class="media">
                            <div class="media-left media-middle" id="profile_pic">
                                <img style="width: 100px;" src="../../images/users/avatar1.png" class="media-object" alt="Profile Photo">
                            </div>
                            <div class="media-body">
                                <h4 class="media-heading">Hermenegilda Martins da Silva</h4>
                                <h5 id="team_role">Team Manager</h5>
                                <i class="fa fa-search-plus fa-2x" data-toggle="collapse" data-target="#profile_details1"></i>
                            </div>
                       </div>
                       <div id="profile_details1" class="collapse">
                         <div class="profile_details">
                           <hr />
                           <div class="row">
                             <div class="col-xs-1">
                             </div>
                             <div class="col-xs-3" align="center">
                              <p>From:</p>
                             </div>
                             <div class="col-xs-7">
                               <p class="attribute_field">Vila Nova de Gaia, Portugal</p>
                             </div>
                             <div class="col-xs-1">
                             </div>
                           </div>
                           <div class="row">
                             <div class="col-xs-1"></div>
                             <div class="col-xs-3" align="center">
                              <p>Email:</p>
                             </div>
                             <div class="col-xs-7">
                               <p class="attribute_field">gildazita@gmail.com</p>
                             </div>
                             <div class="col-xs-1"></div>
                           </div>
                           <div class="row">
                             <div class="col-xs-1"></div>
                             <div class="col-xs-3" align="center">
                              <p>Phone:</p>
                             </div>
                             <div class="col-xs-7">
                               <p class="attribute_field">910-900-999</p>
                             </div>
                             <div class="col-xs-1"></div>
                           </div>
                           <div class="row">
                             <div class="col-xs-1"></div>
                             <div class="col-xs-3" align="center">
                              <p>Profile:</p>
                             </div>
                             <div class="col-xs-7">
                               <a class="attribute_field">direkt.com/1</a>
                             </div>
                             <div class="col-xs-1"></div>
                           </div>
                           <hr />
                           <div class="row" id="profile_actions">
                             <div class="col-xs-3"></div>
                             <div class="col-xs-3" align="center">
                               <span class="fa-stack fa-lg" id="promote1" data-toggle="modal" data-target="#demote_member_dialog">
                                <i class="fa fa-star fa-stack-1x"></i>
                                <i class="fa fa-ban fa-stack-2x"></i>
                              </span>
                             </div>
                             <div class="col-xs-3" align="center">
                               <i class="fa fa-times fa-3x" id="remove1" data-toggle="modal" data-target="#remove_member_dialog"></i>
                             </div>
                             <div class="col-xs-3"></div>
                           </div>
                           <div class="col-xs-12" id="zoom_out_action">
                             <i class="fa fa-search-minus fa-2x" data-toggle="collapse" data-target="#profile_details1" id="zoom_out"></i>
                           </div>
                         </div>
                       </div>
                     </div>
                   </div>
                 </div>
<!-- Second Avatar -->
                       <div class="col-md-4">
                           <div class="panel panel-default" id="profile_card">
                               <div class="panel-body">
                                  <div class="media">
                                       <div class="media-left media-middle" id="profile_pic">
                                           <img style="width: 100px;" src="../../images/users/avatar2.png" class="media-object" alt="Profile Photo">
                                       </div>
                                       <div class="media-body">
                                           <h4 class="media-heading">Virgílio Mota das Torres Cruz</h4>
                                           <h5 id="team_role">Team Member</h5>
                                           <i class="fa fa-search-plus fa-2x" data-toggle="collapse" data-target="#profile_details2"></i>
                                       </div>
                                  </div>
                                  <div id="profile_details2" class="collapse">
                                    <div class="profile_details">
                                      <hr />
                                      <div class="row">
                                        <div class="col-xs-1">
                                        </div>
                                        <div class="col-xs-3" align="center">
                                         <p>From:</p>
                                        </div>
                                        <div class="col-xs-7">
                                          <p class="attribute_field">Braga, Portugal</p>
                                        </div>
                                        <div class="col-xs-1">
                                        </div>
                                      </div>
                                      <div class="row">
                                        <div class="col-xs-1"></div>
                                        <div class="col-xs-3" align="center">
                                         <p>Email:</p>
                                        </div>
                                        <div class="col-xs-7">
                                          <p class="attribute_field">vimote@gmail.com</p>
                                        </div>
                                        <div class="col-xs-1"></div>
                                      </div>
                                      <div class="row">
                                        <div class="col-xs-1"></div>
                                        <div class="col-xs-3" align="center">
                                         <p>Phone:</p>
                                        </div>
                                        <div class="col-xs-7">
                                          <p class="attribute_field">969-696-969</p>
                                        </div>
                                        <div class="col-xs-1"></div>
                                      </div>
                                      <div class="row">
                                        <div class="col-xs-1"></div>
                                        <div class="col-xs-3" align="center">
                                         <p>Profile:</p>
                                        </div>
                                        <div class="col-xs-7">
                                          <a class="attribute_field">direkt.com/user2</a>
                                        </div>
                                        <div class="col-xs-1"></div>
                                      </div>
                                      <hr />
                                      <div class="row" id="profile_actions">
                                        <div class="col-xs-3"></div>
                                        <div class="col-xs-3" align="center">
                                         <i class="fa fa-star fa-3x" id="promote2" data-toggle="modal" data-target="#promote_member_dialog"></i>
                                        </div>
                                        <div class="col-xs-3" align="center">
                                          <i class="fa fa-times fa-3x" id="remove2" data-toggle="modal" data-target="#remove_member_dialog"></i>
                                        </div>
                                        <div class="col-xs-3"></div>
                                      </div>
                                      <div class="col-xs-12" id="zoom_out_action">
                                        <i class="fa fa-search-minus fa-2x" data-toggle="collapse" data-target="#profile_details2" id="zoom_out"></i>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                            </div>
                        </div>
<!-- Third Avatar -->
                        <div class="col-md-4">
                            <div class="panel panel-default" id="profile_card">
                                <div class="panel-body">
                                   <div class="media">
                                        <div class="media-left media-middle" id="profile_pic">
                                            <img style="width: 100px;" src="../../images/users/avatar3.png" class="media-object" alt="Profile Photo">
                                        </div>
                                        <div class="media-body">
                                            <h4 class="media-heading">Josefino Mário Paredes Touca</h4>
                                            <h5 id="team_role">Team Member</h5>
                                            <i class="fa fa-search-plus fa-2x" data-toggle="collapse" data-target="#profile_details3"></i>
                                        </div>
                                   </div>
                                   <div id="profile_details3" class="collapse">
                                     <div class="profile_details">
                                       <hr />
                                       <div class="row">
                                         <div class="col-xs-1">
                                         </div>
                                         <div class="col-xs-3" align="center">
                                          <p>From:</p>
                                         </div>
                                         <div class="col-xs-7">
                                           <p class="attribute_field">Paredes de Coura, Portugal</p>
                                         </div>
                                         <div class="col-xs-1">
                                         </div>
                                       </div>
                                       <div class="row">
                                         <div class="col-xs-1"></div>
                                         <div class="col-xs-3" align="center">
                                          <p>Email:</p>
                                         </div>
                                         <div class="col-xs-7">
                                           <p class="attribute_field">olamail@gmail.com</p>
                                         </div>
                                         <div class="col-xs-1"></div>
                                       </div>
                                       <div class="row">
                                         <div class="col-xs-1"></div>
                                         <div class="col-xs-3" align="center">
                                          <p>Phone:</p>
                                         </div>
                                         <div class="col-xs-7">
                                           <p class="attribute_field">999-999-999</p>
                                         </div>
                                         <div class="col-xs-1"></div>
                                       </div>
                                       <div class="row">
                                         <div class="col-xs-1"></div>
                                         <div class="col-xs-3" align="center">
                                          <p>Profile:</p>
                                         </div>
                                         <div class="col-xs-7">
                                           <a class="attribute_field">direkt.com/user1</a>
                                         </div>
                                         <div class="col-xs-1"></div>
                                       </div>
                                       <hr />
                                       <div class="row" id="profile_actions">
                                         <div class="col-xs-3"></div>
                                         <div class="col-xs-3" align="center">
                                          <i class="fa fa-star fa-3x" id="promote3" data-toggle="modal" data-target="#promote_member_dialog"></i>
                                         </div>
                                         <div class="col-xs-3" align="center">
                                           <i class="fa fa-times fa-3x" id="remove3" data-toggle="modal" data-target="#remove_member_dialog"></i>
                                         </div>
                                         <div class="col-xs-3"></div>
                                       </div>
                                       <div class="col-xs-12" id="zoom_out_action">
                                         <i class="fa fa-search-minus fa-2x" data-toggle="collapse" data-target="#profile_details3" id="zoom_out"></i>
                                       </div>
                                     </div>
                                   </div>
                                 </div>
                             </div>
                         </div>
                       </div>
<!-- Fourth Avatar -->
                      <div class="row">
                         <div class="col-md-4">
                             <div class="panel panel-default" id="profile_card">
                                 <div class="panel-body">
                                    <div class="media">
                                         <div class="media-left media-middle" id="profile_pic">
                                             <img style="width: 100px;" src="../../images/users/avatar4.png" class="media-object" alt="Profile Photo">
                                         </div>
                                         <div class="media-body">
                                             <h4 class="media-heading">Fábinho Coentrão das Sopas Júnior</h4>
                                             <h5 id="team_role">Team Member</h5>
                                             <i class="fa fa-search-plus fa-2x" data-toggle="collapse" data-target="#profile_details4"></i>
                                         </div>
                                    </div>
                                    <div id="profile_details4" class="collapse">
                                      <div class="profile_details">
                                        <hr />
                                        <div class="row">
                                          <div class="col-xs-1">
                                          </div>
                                          <div class="col-xs-3" align="center">
                                           <p>From:</p>
                                          </div>
                                          <div class="col-xs-7">
                                            <p class="attribute_field">Porto, Portugal</p>
                                          </div>
                                          <div class="col-xs-1">
                                          </div>
                                        </div>
                                        <div class="row">
                                          <div class="col-xs-1"></div>
                                          <div class="col-xs-3" align="center">
                                           <p>Email:</p>
                                          </div>
                                          <div class="col-xs-7">
                                            <p class="attribute_field">fabinho@iol.yahoo.br</p>
                                          </div>
                                          <div class="col-xs-1"></div>
                                        </div>
                                        <div class="row">
                                          <div class="col-xs-1"></div>
                                          <div class="col-xs-3" align="center">
                                           <p>Phone:</p>
                                          </div>
                                          <div class="col-xs-7">
                                            <p class="attribute_field">999-999-999</p>
                                          </div>
                                          <div class="col-xs-1"></div>
                                        </div>
                                        <div class="row">
                                          <div class="col-xs-1"></div>
                                          <div class="col-xs-3" align="center">
                                           <p>Profile:</p>
                                          </div>
                                          <div class="col-xs-7">
                                            <a class="attribute_field">direkt.com/user1</a>
                                          </div>
                                          <div class="col-xs-1"></div>
                                        </div>
                                        <hr />
                                        <div class="row" id="profile_actions">
                                          <div class="col-xs-3"></div>
                                          <div class="col-xs-3" align="center">
                                           <i class="fa fa-star fa-3x" id="promote4" data-toggle="modal" data-target="#promote_member_dialog"></i>
                                          </div>
                                          <div class="col-xs-3" align="center">
                                            <i class="fa fa-times fa-3x" id="remove4" data-toggle="modal" data-target="#remove_member_dialog"></i>
                                          </div>
                                          <div class="col-xs-3"></div>
                                        </div>
                                        <div class="col-xs-12" id="zoom_out_action">
                                          <i class="fa fa-search-minus fa-2x" data-toggle="collapse" data-target="#profile_details4" id="zoom_out"></i>
                                        </div>
                                      </div>
                                    </div>
                                  </div>
                              </div>
                          </div>
<!-- Fifth Avatar -->
                          <div class="col-md-4">
                              <div class="panel panel-default" id="profile_card">
                                  <div class="panel-body">
                                     <div class="media">
                                          <div class="media-left media-middle" id="profile_pic">
                                              <img style="width: 100px;" src="../../images/users/avatar5.jpg" class="media-object" alt="Profile Photo">
                                          </div>
                                          <div class="media-body">
                                              <h4 class="media-heading">Armindo António Armindo Branco Felicidade</h4>
                                              <h5 id="team_role">Team Member</h5>
                                              <i class="fa fa-search-plus fa-2x" data-toggle="collapse" data-target="#profile_details5"></i>
                                          </div>
                                     </div>
                                     <div id="profile_details5" class="collapse">
                                       <div class="profile_details">
                                         <hr />
                                         <div class="row">
                                           <div class="col-xs-1">
                                           </div>
                                           <div class="col-xs-3" align="center">
                                            <p>From:</p>
                                           </div>
                                           <div class="col-xs-7">
                                             <p class="attribute_field">Castelo Branco, Portugal</p>
                                           </div>
                                           <div class="col-xs-1">
                                           </div>
                                         </div>
                                         <div class="row">
                                           <div class="col-xs-1"></div>
                                           <div class="col-xs-3" align="center">
                                            <p>Email:</p>
                                           </div>
                                           <div class="col-xs-7">
                                             <p class="attribute_field">aaarmindorepete@gmail.com</p>
                                           </div>
                                           <div class="col-xs-1"></div>
                                         </div>
                                         <div class="row">
                                           <div class="col-xs-1"></div>
                                           <div class="col-xs-3" align="center">
                                            <p>Phone:</p>
                                           </div>
                                           <div class="col-xs-7">
                                             <p class="attribute_field">999-999-999</p>
                                           </div>
                                           <div class="col-xs-1"></div>
                                         </div>
                                         <div class="row">
                                           <div class="col-xs-1"></div>
                                           <div class="col-xs-3" align="center">
                                            <p>Profile:</p>
                                           </div>
                                           <div class="col-xs-7">
                                             <a class="attribute_field">direkt.com/user1</a>
                                           </div>
                                           <div class="col-xs-1"></div>
                                         </div>
                                         <hr />
                                         <div class="row" id="profile_actions">
                                           <div class="col-xs-3"></div>
                                           <div class="col-xs-3" align="center">
                                            <i class="fa fa-star fa-3x" id="promote5" data-toggle="modal" data-target="#promote_member_dialog"></i>
                                           </div>
                                           <div class="col-xs-3" align="center">
                                             <i class="fa fa-times fa-3x" id="remove5" data-toggle="modal" data-target="#remove_member_dialog"></i>
                                           </div>
                                           <div class="col-xs-3"></div>
                                         </div>
                                         <div class="col-xs-12" id="zoom_out_action">
                                           <i class="fa fa-search-minus fa-2x" data-toggle="collapse" data-target="#profile_details5" id="zoom_out"></i>
                                         </div>
                                       </div>
                                     </div>
                                   </div>
                               </div>
                           </div>
<!-- Sixth Avatar -->
                           <div class="col-md-4">
                               <div class="panel panel-default" id="profile_card">
                                   <div class="panel-body">
                                      <div class="media">
                                           <div class="media-left media-middle" id="profile_pic">
                                               <img style="width: 100px;" src="../../images/users/avatar6.png" class="media-object" alt="Profile Photo">
                                           </div>
                                           <div class="media-body">
                                               <h4 class="media-heading">Bonifácio Jóli DeCáperio Pite Chuárzenéguere</h4>
                                               <h5 id="team_role">Team Member</h5>
                                               <i class="fa fa-search-plus fa-2x" data-toggle="collapse" data-target="#profile_details6"></i>
                                           </div>
                                      </div>
                                      <div id="profile_details6" class="collapse">
                                        <div class="profile_details">
                                          <hr />
                                          <div class="row">
                                            <div class="col-xs-1">
                                            </div>
                                            <div class="col-xs-3" align="center">
                                             <p>From:</p>
                                            </div>
                                            <div class="col-xs-7">
                                              <p class="attribute_field">Porto, Portugal</p>
                                            </div>
                                            <div class="col-xs-1">
                                            </div>
                                          </div>
                                          <div class="row">
                                            <div class="col-xs-1"></div>
                                            <div class="col-xs-3" align="center">
                                             <p>Email:</p>
                                            </div>
                                            <div class="col-xs-7">
                                              <p class="attribute_field">jczelik@gmail.com</p>
                                            </div>
                                            <div class="col-xs-1"></div>
                                          </div>
                                          <div class="row">
                                            <div class="col-xs-1"></div>
                                            <div class="col-xs-3" align="center">
                                             <p>Phone:</p>
                                            </div>
                                            <div class="col-xs-7">
                                              <p class="attribute_field">999-999-999</p>
                                            </div>
                                            <div class="col-xs-1"></div>
                                          </div>
                                          <div class="row">
                                            <div class="col-xs-1"></div>
                                            <div class="col-xs-3" align="center">
                                             <p>Profile:</p>
                                            </div>
                                            <div class="col-xs-7">
                                              <a class="attribute_field">direkt.com/user1</a>
                                            </div>
                                            <div class="col-xs-1"></div>
                                          </div>
                                          <hr />
                                          <div class="row" id="profile_actions">
                                            <div class="col-xs-3"></div>
                                            <div class="col-xs-3" align="center">
                                             <i class="fa fa-star fa-3x" id="promote6" data-toggle="modal" data-target="#promote_member_dialog"></i>
                                            </div>
                                            <div class="col-xs-3" align="center">
                                              <i class="fa fa-times fa-3x" id="remove6" data-toggle="modal" data-target="#remove_member_dialog"></i>
                                            </div>
                                            <div class="col-xs-3"></div>
                                          </div>
                                          <div class="col-xs-12" id="zoom_out_action">
                                            <i class="fa fa-search-minus fa-2x" data-toggle="collapse" data-target="#profile_details6" id="zoom_out"></i>
                                          </div>
                                        </div>
                                      </div>
                                    </div>
                                </div>
                            </div>
                      </div>
                    <div class="row">
                      <div class="col-md-4">
                        <div class="panel panel-default" id="add_member_card">
                            <div class="panel-body">
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
                            </div>
                          </div>
                      </div>
                    </div>
                </div>
            </div>
        </div>

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
        <button type="button" class="btn btn-default" id="accept_button">Yes</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel_button">No</button>
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

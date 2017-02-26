<?php
include_once "common/header.html";
?>
<link href="../css/UI6.css" rel="stylesheet">

<?php

//TODO mudar para ele preencher consoante o número de elementos que tiver
$num_elems = 6;
$elems_per_row = 3;

$num_rows = ceil($num_elems / $elems_per_row);

$num_cols = 3;
$col_division = 12 / $num_cols; //DONT CHANGE. Used for grid position purposes
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
            <?php for($j = 0; $j < $num_cols && $num_elems > 0; $j++, $num_elems--) {?>
            <div class="col-md-<?php echo $col_division; ?>">
                <div class="panel panel-default" id="profile_card">
                    <div class="panel-body">
                      <?php if($num_elems > 1) { ?>
                       <div class="media">
                            <div class="media-left media-middle" id="profile_pic">
                                <img style="width: 100px;" src="../assets/default_image_profile1.jpg" class="media-object" alt="Profile Photo">
                            </div>
                            <div class="media-body">
                                <h4 class="media-heading">José Carlos Milheiro Soares Coutinho</h4>
                                <h5 id="team_role">Team Manager</h5>
                                <i class="fa fa-search-plus fa-2x"></i>
                            </div>
                       </div>
                      <?php } else { ?>
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
                      <?php } ?>
                    </div>
                </div>
            </div>
            <?php } ?>
        </div>
        <?php } ?>
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
?>

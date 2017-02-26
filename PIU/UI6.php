<?php
include_once "common/header.html";
?>
<link href="../css/UI6.css" rel="stylesheet">

<?php
/*
TODO mudar para ele preencher consoante o número de elementos que tiver
$num_elems = 4;
$elems_per_row = 3;
*/
$num_cols = 3;
$num_rows = 3;
$col_division = 12 / $num_cols;
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
            <?php for($j = 0; $j < $num_cols; $j++) {?>
            <div class="col-md-<?php echo $col_division; ?>">
                <div class="panel panel-default">
                    <div class="panel-body">
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

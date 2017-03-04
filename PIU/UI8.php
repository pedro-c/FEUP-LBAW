<?php
include_once "common/header.html";
?>

<link href="../css/profile.css" rel="stylesheet"/>
<script src="../js/pwstrength-bootstrap.min.js"></script>
<script src="../js/profile.js"></script>

<div id="page-wrapper">

    <div class="container-fluid">

        <!-- Page Heading -->
        <div class="row">
            <div class="content col-xs-8 col-md-4 col-xs-offset-2 col-md-offset-4">
                <div class="profile-pic">
                    <img class="img-circle" src="../../assets/avatar5.jpg">
                </div>
                <div class="personal-info">
                    <div class="info">
                        <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
                        <input class="update-info" type="text" placeholder="Duarte Costa">
                    </div>
                    <div class="info">
                        <span class="glyphicon glyphicon-envelope" aria-hidden="true"></span>
                        <input class="update-info" type="email" placeholder="duartecosta@mail.com">
                    </div>
                    <div class="info">
                        <span class="glyphicon glyphicon-flag" aria-hidden="true"></span>
                        <input class="update-info" type="text" placeholder="Portugal">
                    </div>
                    <div class="info">
                        <span class="glyphicon glyphicon-home" aria-hidden="true"></span>
                        <input class="update-info" type="text" placeholder="Porto">
                    </div>
                    <div class="update">
                        <button id="update-button" class="btn btn-success">Update</button>
                    </div>
                </div>
                <div class="password">
                    <h4 id="change-password">Change Password</h4>
                    <div>
                        <input type="text" placeholder="Current Password">
                    </div>
                    <div>
                        <input id="new-password" type="text" placeholder="New Password">
                    </div>
                    <div>
                        <input type="text" placeholder="Repeat Password">
                    </div>
                    <div>
                        <button class="btn btn-success">Update</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



<?php
include_once "common/footer.html";
?>



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
                    <div>
                        <img class="img-circle" src="../../assets/avatar5.jpg">
                    </div>
                    <div>
                        <a href="#">Change Photo</a>
                    </div>
                </div>
                <div class="project-managment">
                    <h4>Join Project</h4>
                    <div class="join-project">
                        <input type="text" placeholder="Insert Project ID">
                        <button class="btn btn-success">Join</button>
                    </div>
                    <h4>Current Projects</h4>
                    <div class="current-projects">
                        <div>
                            <a href="#">Project 1</a>
                        </div>
                        <div>
                            <a href="#">Project 2</a>
                        </div>
                    </div>
                </div>
                <div class="personal-info">
                    <h4 id="change-password">Edit Personal Info</h4>
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



<link href="../css/profile.css" rel="stylesheet"/>
<script src="../javascript/pwstrength-bootstrap.min.js"></script>
<script src="../javascript/profile.js"></script>

<div id="page-wrapper">

    <div class="container-fluid">

        <!-- Page Heading -->
        <div class="row">
            <div class="content col-xs-8 col-md-4 col-xs-offset-2 col-md-offset-4">
                <div class="profile-pic">
                    <div>
                        <img class="img-circle" src="{$user_photo_path}">
                    </div>
                    <div>
                        <a href="#">Change Photo</a>
                    </div>
                </div>
                <div class="project-managment">
                    <h4>Current Projects</h4>
                    <div class="current-projects">

                        {foreach $projects as $project}

                            {$project_name = getProjectName($project.id_project)}
                            <div>
                                <a onclick="changeProject({$project.id_project})">{$project_name}</a>
                            </div>
                        {/foreach}
                    </div>
                    <h4>Join Project</h4>
                    <div class="join-project">
                        <input type="text" placeholder="Insert Project ID">
                        <button class="btn btn-success">Join</button>
                    </div>
                    <h4>New Project</h4>
                    <div class="new-project" id="new_project">
                        <input type="text" placeholder="Insert Project ID">
                        <button class="btn btn-success">Create</button>
                    </div>
                </div>
                <div class="personal-info">
                    <h4 id="change-password">Edit Personal Info</h4>
                    <div class="info">
                        <span class="glyphicon glyphicon-user" aria-hidden="true"></span>
                        <input class="update-info" id="update-user-name" type="text" value="{$user.name}">
                    </div>
                    <div class="info">
                        <span class="glyphicon glyphicon-envelope" aria-hidden="true"></span>
                        <input class="update-info" id="update-user-email" type="email" value="{$user.email}">
                    </div>
                    <div class="info">
                        <span class="glyphicon glyphicon-flag" aria-hidden="true"></span>
                        <input class="update-info" id="update-user-country" type="text" value="{$country}">
                    </div>
                    <div class="info">
                        <span class="glyphicon glyphicon-home" aria-hidden="true"></span>
                        <input class="update-info" id="update-user-city" type="text" value="{$user.city}">
                    </div>
                    <div class="update">
                        <button id="update-button" class="btn btn-success" onclick="updateUserInfo()">Update</button>
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



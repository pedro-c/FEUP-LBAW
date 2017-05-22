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
                        <form action="../actions/users/upload-user-photo.php" method="post" enctype="multipart/form-data">
                            <a id="user-image-upload">
                                <img class="img-circle" src="{$user_photo_path}">
                            </a>
                            <input style="display:none" onchange="this.form.submit()" id="image-upload-button" name="file" type="file"/><br />
                            <span class="error_messages">{$ERROR_MESSAGES[0]}</span>
                        </form>
                    </div>
                </div>
                <div class="project-managment">
                    <h4>Current Projects</h4>
                    <div class="current-projects">

                        {foreach $projects as $project}

                            {$project_name = getProjectName($project.id_project)}
                            <div>
                                <a onclick="changeProject({$project.id_project})">{$project_name}</a>
                                <span type="button" class="glyphicon glyphicon-log-out" aria-hidden="true" data-toggle="modal" data-target="#{$project.id_project}"></span>
                            </div>

                            <!-- Modal -->
                            <div id="{$project.id_project}" class="modal fade" role="dialog">
                                <div class="modal-dialog">

                                    <!-- Modal content-->
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title">Leave project {$project_name}</h4>
                                        </div>
                                        <div class="modal-body">
                                            <p>Are you sure you want to leave?</p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-danger" data-dismiss="modal" onclick="leaveProject({$project.id_project})">Yes</button>
                                        </div>
                                    </div>

                                </div>
                            </div>

                        {/foreach}


                    </div>
                    <h4>Join Project</h4>
                    <div class="join-project">
                        <input type="text" id="join-project-id" placeholder="Insert Project ID">
                        <button class="btn btn-success" onclick="joinProject()">Join</button>
                    </div>
                    <h4>New Project</h4>
                    <div class="new-project" id="new_project">
                        <input type="text" id="create-project-name" placeholder="Insert Project Name">
                        <button class="btn btn-success" onclick="createProject()">Create</button>
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
                        <select id="selected-country" >
                            {foreach $countries as $country}
                                {if $country.name eq $user_country['0'].name}
                                    <option selected="selected" value="{$user.country_id}">{$user_country['0'].name}</option>
                                {else}
                                    <option value="{$country.id}">{$country.name}</option>
                                {/if}
                            {/foreach}
                        </select>
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
                    <form action="{$BASE_URL}actions/users/change-password.php" method="post">
                        <h4 id="change-password">Change Password</h4>
                        <div>
                            <input name="old-password" type="password" placeholder="Current Password">
                            <span class="error_messages">{$ERROR_MESSAGES[0]}</span>
                        </div>
                        <div>
                            <input name="new-password" id="new-password" type="password" placeholder="New Password">
                            <span class="error_messages">{$ERROR_MESSAGES[1]}</span>
                        </div>
                        <div>
                            <input name="repeat-password" type="password" placeholder="Repeat Password">
                            <span class="error_messages">{$ERROR_MESSAGES[2]}</span>
                        </div>
                        <div>
                            <input class="btn btn-success" type="submit" value="Update">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>



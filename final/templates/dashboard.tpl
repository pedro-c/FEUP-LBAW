<link href="../css/UI2.css" rel="stylesheet"/>
<script src="../javascript/files.js"></script>

<div class="page-wrapper container">
    <div class="row"><br>
        <div id="project-presentation" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <div class="page-header">
                <div id="project-title">
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                    <h2 id="title"> {$projectName} </h2>
                </div>
                <div id="project-description">
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                    <span id="subtitle">{$projectDescription}</span>
                </div>
            </div>
        </div>
        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12 dash-card">
            <div class="panel panel-primary">
                <a href="#" class="panel-heading">
                    <h4 class="panel-title"><i class="glyphicon glyphicon-check dash-title-icon"></i> Your Tasks
                        <span class="to-page glyphicon glyphicon-menu-right"></span>
                    </h4>
                </a>
                <div class="panel-body">
                    <div class="list-group">
                        {foreach $uncompletedTasks as $task}

                        <button class="list-group-item">
                            <i class="glyphicon glyphicon-menu-right dash-icon"></i>
                            <span class="dash-item-text"> {$task.name}</span>
                            <span class="dash-item-text"> Assigned to: {$taskName=getTaskAssignedName($task.id)}{$taskName.name}</span>
                        </button>
                        {/foreach}
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6 col-md-6 col-sm-12 col-xs-12 dash-card">
            <div class="panel panel-primary">
                <a href="#" class="panel-heading">
                    <h4 class="panel-title"><i class="fa fa-quote-right dash-title-icon"></i> Forum
                        <span class="to-page glyphicon glyphicon-menu-right"></span>
                    </h4>
                </a>
                <div class="panel-body">
                    <div class="list-group">
                        <button class="list-group-item">
                            <div class="row">
                                <span class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                                    <i class="glyphicon glyphicon-menu-right dash-icon"></i><span
                                            class="dash-item-text">Don't forget to comment</span>
                                </span>
                                <span class="dash-item-user col-lg-5 col-md-5 col-sm-5 col-xs-5 col-lg-offset-1 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                        <img src="../images/users/avatar2.png" class="dash-user-thumb"/><span
                                            class="dash-item-username"><small>epassos</small></span>
                                </span>
                            </div>
                        </button>
                        <button class="list-group-item">
                            <div class="row">
                                <span class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <i class="glyphicon glyphicon-menu-right dash-icon"></i><span class="dash-item-text">Great JS resource</span>
                                </span>
                                <span class="dash-item-user col-lg-5 col-md-5 col-sm-5 col-xs-5 col-lg-offset-1 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                        <img src="../images/users/avatar6.png" class="dash-user-thumb"/><span
                                            class="dash-item-username"><small>pedroc</small></span>
                                </span>
                            </div>
                        </button>
                        <button class="list-group-item">
                            <div class="row">
                                <span class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <i class="glyphicon glyphicon-menu-right dash-icon"></i><span class="dash-item-text">Some changes needed</span>
                                </span>
                                <span class="dash-item-user col-lg-5 col-md-5 col-sm-5 col-xs-5 col-lg-offset-1 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                        <img src="../images/users/avatar1.png" class="dash-user-thumb"/><span
                                            class="dash-item-username"><small>mariajoaomp</small></span>
                                </span>
                            </div>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="clearfix"></div>
        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12 dash-card">
            <div class="panel panel-primary">
                <a href="../pages/meetings.php" class="panel-heading">
                    <h4 class="panel-title"><i class="fa fa-calendar dash-title-icon"></i> Meetings
                        <span class="to-page glyphicon glyphicon-menu-right"></span>
                    </h4>
                </a>
                <div class="panel-body">
                    <div class="list-group">
                        {foreach $meetings as $meeting}
                            <button class="list-group-item">
                                <i class="glyphicon glyphicon-menu-right dash-icon"></i><span class="dash-item-text">{$meeting.name}</span>
                                <small class="dash-date">{$meeting.date|substr:0:10}</small>
                            </button>
                        {/foreach}
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 dash-card">
            <div class="panel panel-primary">
                <a href="../pages/files.php" class="panel-heading">
                    <h4 class="panel-title"><i class="glyphicon glyphicon-file dash-title-icon"></i> Files
                        <span class="to-page glyphicon glyphicon-menu-right"></span>
                    </h4>
                </a>
                <div class="panel-body">
                    <div class="list-group">
                        {foreach $files as $file}
                            {$uploader_name = getNickNameById($file.uploader_id)}
                            {$photo_path = getPhoto($file.uploader_id)}
                            <button class="list-group-item">
                                <div class="row">
                                <span class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                               <img class="file_show" src="../images/assets/excel.png"><span class="dash-item-text">{$file.name|truncate:18}</span>
                                </span>
                                    <span class="dash-item-user col-lg-5 col-md-5 col-sm-5 col-xs-5 col-lg-offset-1 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                        <img src={$photo_path} class="dash-user-thumb"/><span
                                                class="dash-item-username"><small>{$uploader_name}</small></span>
                                </span>
                                </div>
                            </button>
                        {/foreach}
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 dash-card">
            <div class="panel panel-primary">
                <a href="#" class="panel-heading">
                    <h4 class="panel-title"><i class="fa fa-users dash-title-icon"></i> The Team
                        <span class="to-page glyphicon glyphicon-menu-right"></span>
                    </h4>
                </a>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <div href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../images/users/avatar2.png"/>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../images/users/avatar7.png"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../images/users/avatar6.png"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../images/users/avatar5.jpg"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../images/users/avatar4.png"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../images/users/avatar3.png"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../images/users/avatar1.png"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

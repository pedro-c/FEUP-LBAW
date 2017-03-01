<?php
include_once 'common/header.html';
?>
<link href="../css/ui2.css" rel="stylesheet"/>
<script src="../js/dashboard.js"></script>
<div class="page-wrapper container">
    <div class="row"><br>
        <div id="project-presentation" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <div class="page-header">
                <h2 id="title">My Project</h2>
                <span id="subtitle">
                        Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eligendi non quis exercitationem culpa
                        nesciunt nihil aut nostrum explicabo reprehenderit optio amet ab temporibus asperiores quasi
                        cupiditate. Voluptatum ducimus voluptates voluptas?
                    </span>
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
                        <button class="list-group-item"><i class="glyphicon glyphicon-menu-right dash-icon"></i><span
                                    class="dash-item-text">Implement feature</span></button>
                        <button class="list-group-item"><i class="glyphicon glyphicon-menu-right dash-icon"></i><span
                                    class="dash-item-text">Merge changes</span></button>
                        <button class="list-group-item"><i class="glyphicon glyphicon-menu-right dash-icon"></i><span
                                    class="dash-item-text">Fix conflicts</span></button>
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
                                        <img src="../assets/avatar2.png" class="dash-user-thumb"/><span
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
                                        <img src="../assets/avatar6.png" class="dash-user-thumb"/><span
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
                                        <img src="../assets/avatar1.png" class="dash-user-thumb"/><span
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
                <a href="#" class="panel-heading">
                    <h4 class="panel-title"><i class="fa fa-calendar dash-title-icon"></i> Meetings
                        <span class="to-page glyphicon glyphicon-menu-right"></span>
                    </h4>
                </a>
                <div class="panel-body">
                    <div class="list-group">
                        <button class="list-group-item">
                            <i class="glyphicon glyphicon-menu-right dash-icon"></i><span class="dash-item-text">General Meeting</span>
                            <small class="dash-date">09-03-2017</small>
                        </button>
                        <button class="list-group-item">
                            <i class="glyphicon glyphicon-menu-right dash-icon"></i><span class="dash-item-text">Last Checkup</span>
                            <small class="dash-date">24-03-2017</small>
                        </button>
                        <button class="list-group-item">
                            <i class="glyphicon glyphicon-menu-right dash-icon"></i><span class="dash-item-text">Deadline Meeting</span>
                            <small class="dash-date">30-03-2017</small>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 dash-card">
            <div class="panel panel-primary">
                <a href="#" class="panel-heading">
                    <h4 class="panel-title"><i class="glyphicon glyphicon-file dash-title-icon"></i> Files
                        <span class="to-page glyphicon glyphicon-menu-right"></span>
                    </h4>
                </a>
                <div class="panel-body">
                    <div class="list-group">
                        <button class="list-group-item">
                            <div class="row">
                                <span class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <i class="fa fa-file-excel-o dash-icon"></i><span class="dash-item-text">clients.xls</span>
                                </span>
                                <span class="dash-item-user col-lg-5 col-md-5 col-sm-5 col-xs-5 col-lg-offset-1 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                        <img src="../assets/avatar1.png" class="dash-user-thumb"/><span
                                            class="dash-item-username"><small>mariajoaomp</small></span>
                                </span>
                            </div>
                        </button>
                        <button class="list-group-item">
                            <div class="row">
                                <span class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <i class="fa fa-file-pdf-o dash-icon"></i>
                                <span class="dash-item-text">requirements.pdf</span>
                                </span>
                                <span class="dash-item-user col-lg-5 col-md-5 col-sm-5 col-xs-5 col-lg-offset-1 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                        <img src="../assets/avatar2.png" class="dash-user-thumb"/><span
                                            class="dash-item-username"><small>epassos</small></span>
                                </span>
                            </div>
                        </button>
                        <button class="list-group-item">
                            <div class="row">
                                <span class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                            <i class="fa fa-file-pdf-o dash-icon"></i>
                                <span class="dash-item-text">team_guide.pdf</span>
                                </span>
                                <span class="dash-item-user col-lg-5 col-md-5 col-sm-5 col-xs-5 col-lg-offset-1 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                        <img src="../assets/avatar3.png" class="dash-user-thumb"/><span
                                            class="dash-item-username"><small>jccoutinho</small></span>
                                </span>
                            </div>
                        </button>
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
                                <img alt="Team member picture" src="../assets/avatar2.png"/>
                            </div>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../assets/avatar7.png"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../assets/avatar6.png"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../assets/avatar5.jpg"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../assets/avatar4.png"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../assets/avatar3.png"/>
                            </a>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3 col-xs-6">
                            <a href="#" class="dash-thumbnail thumbnail">
                                <img alt="Team member picture" src="../assets/avatar1.png"/>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

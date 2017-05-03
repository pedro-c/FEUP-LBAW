<?php /* Smarty version Smarty-3.1.15, created on 2017-05-03 18:01:28
         compiled from "/opt/lbaw/lbaw1614/public_html/final/templates/dashboard.tpl" */ ?>
<?php /*%%SmartyHeaderCode:731498096590a0ce85026a6-02254059%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'fd64fa6ab29500e0f31ffa47edf811e08b812975' => 
    array (
      0 => '/opt/lbaw/lbaw1614/public_html/final/templates/dashboard.tpl',
      1 => 1493830862,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '731498096590a0ce85026a6-02254059',
  'function' => 
  array (
  ),
  'variables' => 
  array (
    'projectName' => 0,
    'projectDescription' => 0,
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.15',
  'unifunc' => 'content_590a0ce867a282_74726885',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_590a0ce867a282_74726885')) {function content_590a0ce867a282_74726885($_smarty_tpl) {?><link href="../css/UI2.css" rel="stylesheet"/>

<div class="page-wrapper container">
    <div class="row"><br>
        <div id="project-presentation" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <div class="page-header">
                <div id="project-title">
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                    <h2 id="title"> <?php echo $_smarty_tpl->tpl_vars['projectName']->value;?>
 </h2>
                </div>
                <div id="project-description">
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                    <span id="subtitle"><?php echo $_smarty_tpl->tpl_vars['projectDescription']->value;?>
</span>
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
                        <button class="list-group-item"><i class="glyphicon glyphicon-menu-right dash-icon"></i><span
                                    class="dash-item-text">Implement feature</span></button>
                        <button class="list-group-item"><i class="glyphicon glyphicon-menu-right dash-icon"></i><span
                                    class="dash-item-text">Merge changes</span></button>
                        <button class="list-group-item">
                            <i class="glyphicon glyphicon-menu-right dash-icon"></i><span
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
                               <img class="file_show" src="../images/assets/excel.png"><span class="dash-item-text">clients.xls</span>
                                </span>
                                <span class="dash-item-user col-lg-5 col-md-5 col-sm-5 col-xs-5 col-lg-offset-1 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                        <img src="../images/users/avatar1.png" class="dash-user-thumb"/><span
                                            class="dash-item-username"><small>mariajoaomp</small></span>
                                </span>
                            </div>
                        </button>
                        <button class="list-group-item">
                            <div class="row">
                                <span class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
                              <img class="file_show" src="../images/assets/pdf.png">
                                <span class="dash-item-text">requirements.pdf</span>
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
                             <img class="file_show" src="../images/assets/file.png">
                                <span class="dash-item-text">team_guide.pdf</span>
                                </span>
                                <span class="dash-item-user col-lg-5 col-md-5 col-sm-5 col-xs-5 col-lg-offset-1 col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
                                        <img src="../images/users/avatar3.png" class="dash-user-thumb"/><span
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
<?php }} ?>

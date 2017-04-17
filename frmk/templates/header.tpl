<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">



    <title>Direkt</title>

    <!-- Bootstrap Core CSS -->
    <link href="../css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="../css/global.css" rel="stylesheet">
    <link href="../css/bootstrap-datepicker3.css" rel="stylesheet">
    <link href="../css/bootstrap-datepicker.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="../lib/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <!-- jQuery -->
    <!-- jQuery -->
    <script src="../javascript/jquery.js"></script>
    <script src="../javascript/bootstrap.min.js"></script>
    <script src="../javascript/bootstrap-datepicker.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.3/js/select2.min.js"></script>
    <script src="../javascript/header.js"></script>


</head>

<body>

<nav class="navbar navbar-default navbar-static-top" id="header">
    <div class="container-fluid">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">
                <img src="../images/assets/logo.png" alt="Direkt"/>
            </a>
            <a href="#" class="mobile-user-options hidden-lg hidden-md hidden-sm">
                <img src="../images/users/avatar2.png" alt="Your Picture" class="user-collapse-picture"/>
                <span>{$name}</span>
            </a>
        </div>

        <div id="sidebar">
            <ul class="nav navbar-nav hidden-xs" >
                <li>
                    <a href="../pages/dashboard.php"><i class="fa fa-home fa-2x"></i><p>Dashboard</p></a>
                </li>
                <li>
                    <a href="../pages/tasks.php"><i class="fa fa-check-square-o fa-2x"></i><p>Tasks</p></a>
                </li>
                <li>
                    <a href="../pages/forum.php"><i class="fa fa-quote-right fa-2x"></i><p>Forum</p></a>
                </li>
                <li>
                    <a href="../pages/meetings.php"><i class="fa fa-calendar-o fa-2x"></i><p>Meetings</p></a>
                </li>
                <li>
                    <a href="../pages/PIU/UI5.php"><i class="fa fa-file fa-2x"></i><p>Files</p></a>
                </li>
                <li>
                    <a href="../pages/PIU/UI6_coordinator.php"><i class="fa fa-users fa-2x"></i><p>Team</p></a>
                </li>
            </ul>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="navbar">
            <div id="sidebar-resp" class="hidden-lg hidden-md hidden-sm">
                <div class="row">
                    <ul class="nav navbar-nav" >
                        <li class="col-xs-6">
                            <a href="../../dashboard.php"><i class="fa fa-home fa-2x"></i><p>Dashboard</p></a>
                        </li>
                        <li class="col-xs-6">
                            <a href="../../tasks.php"><i class="fa fa-check-square-o fa-2x"></i><p>Tasks</p></a>
                        </li>
                        <li class="col-xs-6">
                            <a href="../../forum.php"><i class="fa fa-quote-right fa-2x"></i><p>Forum</p></a>
                        </li>
                        <li class="col-xs-6">
                            <a href="../../meetings.php"><i class="fa fa-calendar-o fa-2x"></i><p>Meetings</p></a>
                        </li>
                        <li class="col-xs-6">
                            <a href="../UI5.php"><i class="fa fa-file fa-2x"></i><p>Files</p></a>
                        </li>
                        <li class="col-xs-6">
                            <a href="../UI6_coordinator.php"><i class="fa fa-users fa-2x"></i><p>Team</p></a>
                        </li>
                        <li  class="col-xs-6">
                            <a href="#"> <i class="fa fa-refresh fa-2x"></i> <p>Change Project</p></a>
                        </li>
                        <li  class="col-xs-6">
                            <a href="#"> <i class="fa fa-sign-out fa-2x"></i> <p>Sign Out</p></a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Top Navbar -->
            <div class="nav navbar-nav navbar-right hidden-xs">
                <div id="user-options" class="dropdown">
                    <a class="dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                        <p>
                            <img src="../images/users/avatar2.png" alt="User profile picture" class="nav-user-picture">
                            <span id="nav-username">{$name}</span>
                        </p>
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                        <li><a href="../UI8.php">My Profile</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href={$BASE_URL}actions/users/logout.php>Sign Out<i class="nav-dropdown-icon glyphicon glyphicon-log-out"></i></a></li>
                    </ul>

                </div>
            </div>
            <div class="nav navbar-nav navbar-right hidden-xs">
                <div id="user-projects" class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="true">
                        <p>
                            <i class="glyphicon glyphicon-fire"></i>
                            <span id="nav-project">{$firstProjectName}</span>
                        </p>
                    </a>
                    <ul class="dropdown-menu">

                        {foreach $projects as $project}

                            {$project_name = getProjectName($project.id_project)}
                            <li><a onclick="changeProject({$project.id_project})">{$project_name}</a></li>
                        {/foreach}
                        <li><a href="../PIU/UI8.php#new_project">New Project<i class="nav-dropdown-icon glyphicon glyphicon-plus"></i></a></li>
                    </ul>
                </div>
            </div>
        </div><!-- /.navbar-collapse -->
    </div><!-- /.container-fluid -->
</nav>

<div id="parent">
    <div id="main-content">


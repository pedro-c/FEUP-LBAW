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
    <link href="../css/UI1_novo.css" rel="stylesheet">
    <link href="../css/plugins/morris.css" rel="stylesheet">
    <link href="../lib/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <script src="../javascript/UI1.js"></script>
    <script src="../javascript/jquery.js"></script>


</head>

<body>


<div class="container">
    <div class="row">
        <div class="panel panel-default login-box panelnopadding" >
            <div class="panel-body panelnopadding">
                <div class="col-lg-6 col-sm-6 col-md-6 hidden-xs content_login panelnopadding">
                    <img class="img-responsive" src="../images/assets/2.png"
                         style="width:100%;overflow: hidden; height: 100%;"/>
                </div>
                <div class="col-lg-6 col-sm-6 col-md-6 col-xs-12 content_login pull-right panelnopadding">
                    <div class="row row-centered">
                        <div class="description-links">
                            <div class="col-xs-12 nopadding">
                                <a class="sign-in-title" onclick="signIn()">Sign In</a>
                                <span class="or-title"> or </span>
                                <a class="sign-up-title" onclick="signUp()">Sign Up</a>
                            </div>
                        </div>
                    </div>
                    <div class="row text-left">
                        <div class="col-xs-12">
                            <div class="form-login">
                                <form action="{$BASE_URL}actions/users/login.php" method="post">
                                    <div class="form-login-right">
                                        <div class="col-xs-12 border-bottom">
                                            <span class="email"> Email: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="email-input-id" name="email" class="email-input"
                                                   placeholder="Enter your email"
                                                   type="text">
                                            <span class="error_messages">{$ERROR_MESSAGES[0]}</span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <span class="password"> Password: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="password-input-id" name="password" class="password-input"
                                                   placeholder="Enter your password"
                                                   type="password">
                                            <span class="error_messages">{$ERROR_MESSAGES[0]}</span>
                                        </div>
                                        <br>
                                    </div>
                                    <div class="col-xs-12 col-login nopadding">
                                        <div class="form-actions nopadding">
                                            <input class="btn btn-default login-button" type="submit" value="Login">
                                        </div>
                                    </div>

                                </form>
                            </div>
                            <div class="form-register" hidden>
                                <form action="{$BASE_URL}actions/users/register.php" method="post">
                                    <div class="form-register-right">

                                        <div class="col-xs-12 border-bottom">
                                            <span class="email"> Email: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="email-input-id" name="email" class="email-input"
                                                   placeholder="Enter your email"
                                                   type="email">
                                            <span class="error_messages">{$FIELD_ERRORS[0]}</span>
                                            <span class="error_messages">{$ERROR_MESSAGES[0]}</span>
                                        </div><br>
                                        <div class="col-xs-12 border-bottom">
                                            <span class="name"> Name: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="name-input-id" name="name" class="name-input"
                                                   placeholder="Enter your name">
                                            <span class="error_messages">{$ERROR_MESSAGES[0]}</span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <span class="username"> Username: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="username-input-id" name="username" class="username-input"
                                                   placeholder="Choose your username"
                                                   type="text">
                                            <span class="error_messages">{$ERROR_MESSAGES[0]}</span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <span class="password"> Password: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="password-input-id" name="password" class="password-input"
                                                   placeholder="Choose your password"
                                                   type="password">
                                            <span class="error_messages">{$ERROR_MESSAGES[0]}</span>

                                        </div>
                                        <br>
                                    </div>
                                    <div class="col-xs-12 col-login nopadding">
                                        <div class="form-actions nopadding">
                                            <input class="btn btn-default register-button" type="submit"
                                                   value="Register">
                                        </div>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</body>
</html>
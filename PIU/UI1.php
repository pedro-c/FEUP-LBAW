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
    <link href="../css/ui1.css" rel="stylesheet">
    <link href="../css/plugins/morris.css" rel="stylesheet">
    <link href="../font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <script src="../js/ui1.js"></script>
    <script src="../jquery-3.1.1.min.js"></script>


</head>

<body>


<div class="container">
    <div class="row vertical-align">
        <div class="col-xs-10 col-xs-offset-1 login-box">
            <div class="border_radius">
                <div class="col-xs-6 content_login nopadding ">
                    <img class="img-responsive" src="../assets/2.png"
                         style="width:100%;overflow: hidden; height: 100%;"/>
                </div>
                <div class="col-xs-6 content_login pull-right">
                    <div class="row">
                        <div class="col-xs-3"></div>
                        <div class="col-xs-3"></div>
                        <div class="col-xs-3 nopadding col-lg-offset-3"> <!--Retirar padding das colunas-->
                            <button class="button_signUp btn btn-default" onclick="signUp()">Sign Up</button>
                        </div>
                        <div class="col-xs-3 nopadding">
                            <button class="button_loginIn btn btn-default" onclick="signIn()">Sign In</button>
                        </div>
                    </div>
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
                                <form>
                                    <div class="form-login-right">
                                        <div class="col-xs-12 border-bottom">
                                            <span class="username"> Username: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="username-input-id" class="username-input"
                                                   placeholder="Enter your username"
                                                   type="text">
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <span class="password"> Password: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="password-input-id" class="password-input"
                                                   placeholder="Enter your password"
                                                   type="password">
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

                            <!--SignUp-->
                            <div class="form-register" hidden>
                                <form>
                                    <div class="form-register-right">

                                        <div class="col-xs-12 border-bottom">
                                            <span class="email"> Email: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="email-input-id" class="email-input"
                                                   placeholder="Enter your email"
                                                   type="email">
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <span class="username"> Username: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="username-input-id" class="username-input"
                                                   placeholder="Choose your username"
                                                   type="text">
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <span class="password"> Password: </span>
                                        </div>
                                        <br>
                                        <div class="col-xs-12 border-bottom">
                                            <input id="password-input-id" class="password-input"
                                                   placeholder="Choose your password"
                                                   type="password">
                                        </div>
                                        <br>
                                    </div>
                                    <div class="col-xs-12 col-login nopadding">
                                        <div class="form-actions nopadding">
                                            <input class="btn btn-default register-button" type="submit" value="Register">
                                        </div>
                                    </div>

                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>


</body>
</html>
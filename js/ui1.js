


function signUp(){
    $(".form-login").hide();
    $(".form-register").show();
    $(".button_loginIn").css("background-color", "#425262");
    $(".button_signUp").css("background-color", "#e9d460");
    $(".sign-in-title").css("border","none");
    $(".sign-in-title").css("color","#425262");
    $(".sign-up-title").css("color","white");
    $(".sign-up-title").css("font-weight", "normal");
    $(".sign-up-title").css("border-bottom", "4px solid");
    $(".sign-up-title").css("border-bottom-color", "#e9d460");
}


function signIn(){
    $(".form-login").show();
    $(".form-register").hide();
    $(".sign-in-title").css("color","white");
    $(".sign-up-title").css("color","#425262");
    $(".button_signUp").css("background-color", "#425262");
    $(".button_loginIn").css("background-color", "#e9d460");
    $(".sign-up-title").css("border","none");
    $(".sign-in-title").css("border-bottom", "4px solid");
    $(".sign-in-title").css("border-bottom-color", "#e9d460");
}
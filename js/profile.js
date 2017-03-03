$(document).ready(function(){
    var updateName = document.getElementById('update-name');
    var updateMail = document.getElementById('update-mail');
    var updateNameButton = document.getElementById('update-name-button');
    var updateMailButton = document.getElementById('update-mail-button');

    $("#update-name").focus(function () {
        $('#update-name-button').show();
    }).blur(function () {
        $('#update-name-button').hide();

    });

    $("#update-mail").focus(function () {
        $('#update-mail-button').show();
    }).blur(function () {
        $('#update-mail-button').hide();

    });

    $("#change-password").click(function () {
       $(".password > div").show();
    });

    var options = {};
    options.ui = {
        container: "#pwd-container",
        showStatus: true,
        showProgressBar: true,
        viewports: {
            verdict: ".pwstrength_viewport_verdict"
        }
    };
    $('#new-password').pwstrength(options);


});
$(document).ready(function(){
    var updateName = document.getElementById('update-name');
    var updateMail = document.getElementById('update-mail');
    var updateNameButton = document.getElementById('update-name-button');
    var updateMailButton = document.getElementById('update-mail-button');

    $(".update-info").focus(function () {
        $('#update-button').show();
    }).blur(function () {
        $('#update-button').hide();

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
$(document).ready(function(){
    var updateName = document.getElementById('update-name');
    var updateMail = document.getElementById('update-mail');
    var updateNameButton = document.getElementById('update-name-button');
    var updateMailButton = document.getElementById('update-mail-button');

    $(".update-info").focus(function () {
        $('#update-button').show();
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

function updateUserInfo() {
    $.ajax({
        type:'post',
        url: '../actions/users/edit-user-info.php',
        data:  {'userName': $('#update-user-name').val(), 'userEmail': $('#update-user-email').val(), 'userCountry': $('#update-user-country').val(), 'userCity': $('#update-user-city').val()},
        success: function() {
            window.location.reload();
        }

    });
}
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

    var $userName=$('#update-user-name').val();
    var $userEmail=$('#update-user-email').val();
    var $userCountry=$('#update-user-country').val();
    var $userCity=$('#update-user-city').val();

    console.log($userName);
    console.log($userEmail);
    console.log($userCountry);
    console.log($userCity);


     $.ajax({
        type:'post',
        url: '../actions/users/edit-user-info.php',
        data:  {'userName': $userName, 'userEmail': $userEmail, 'userCountry': $userCountry, 'userCity': $userCity},
        success: function() {

            console.log("success");

        }

    });
}
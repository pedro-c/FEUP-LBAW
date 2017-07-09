$(document).ready(function () {

    $("li#icon-dash a").css("background-color","#192532");
    $("li#icon-dash a").css("color", "#e9d460");

});

function changeProjectName() {

    var name = $("#new-title").val();

    $.ajax({
        type: 'POST',
        data: { 'name': name} ,
        url:'../api/dashboard/change-project-name.php',
        dataType: 'json',
        success: function (data) {
            console.log(data);
            location.reload();
        }
    });

}

function changeProjectDescription() {
    var description = $("#new-description").val();

    $.ajax({
        type: 'POST',
        data: { 'description': description} ,
        url:'../api/dashboard/change-project-description.php',
        dataType: 'json',
        success: function (data) {
            location.reload();
        }
    });
}


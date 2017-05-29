$(document).ready(function () {

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



function changeProject(projectId){
    $.ajax({
        type: 'POST',
        data: { 'project_id': projectId} ,
        url:'../api/change-project.php',
        success: function () {
            document.location = "dashboard.php";
        }
    });

}

$(document).ready(function(){

    var addTaskButton = $(".task-button");

    addTaskButton.click(function () {

        var clickBtnValue = $(this).val();
        console.log(clickBtnValue);
        var ajaxurl = '../api/tasks/create-task.php',
            data =  {'action': clickBtnValue};
        $.post(ajaxurl, data, function (data) {
            var tasklist = document.getElementById('task-list');
            var row = tasklist.insertRow();
            row.setAttribute("class", "task");
            var cell1 = row.insertCell(0);
            var cell2 = row.insertCell(1);
            var cell3 = row.insertCell(2);
            cell1.innerHTML = "<i class='fa fa-check-circle-o' id='complete-button'></i>";
            cell2.innerHTML = "<div><textarea onclick='toggle();' id='task-title'>New Task</textarea></div>";
            cell3.innerHTML = "<i class='fa fa-times' id='delete-button'></i>";
        });

    });

    $('.input-group.date').datepicker({
        format: "dd/M/yyyy",
        todayHighlight: true
    });

    $('.select2-multiple').select2();

});
function toggle(taskId) {

    $.ajax({
        type:'post',
        url: '../api/tasks/task-details.php',
        data:  {'taskId': taskId},
        success: function(request) {
            /*[{"id":312,"name":"New Task","description":null,"deadline":null,"creator_id":119,"assigned_id":null,"completer_id":null,"project_id":31}]*/

            var response = JSON.parse(request);

            document.getElementById("task-assign").setAttribute("placeholder", response[0].assigned_id);
            document.getElementById("task-name").setAttribute("placeholder", response[0].name);
            document.getElementById("task-description").setAttribute("placeholder", response[0].description);
            document.getElementById("task-assign").setAttribute("placeholder", response[0].assigned_id);
            document.getElementById("task-assign").setAttribute("placeholder", response[0].assigned_id);


            var id = "create-task";
            var taskCard = document.getElementById("task-card");
            var state = document.getElementById(id).style.display;
            if (state != 'none') {
                document.getElementById(id).style.display = 'none';
                document.getElementById(id).style.width = '1%';
                taskCard.style.width = '70%';
                taskCard.style.display = 'inline-block';
                document.getElementById('mobile-back').style.display = 'none';
            } else {
                if ($(window).width() < 768) {
                    taskCard.style.width = '1%';
                    taskCard.style.display = 'none';
                    document.getElementById(id).style.display = 'inline-block';
                    document.getElementById(id).style.width = '70%';
                    document.getElementById('mobile-back').style.display = 'inline-block';
                } else {
                    document.getElementById(id).style.display = 'inline-block';
                    document.getElementById(id).style.width = '40%';
                    taskCard.style.width = '40%';
                    document.getElementById('mobile-back').style.display = 'none';
                }
            }
        }

    });
}
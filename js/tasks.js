/**
 * Created by pedroc on 26/02/17.
 */

$(document).ready(function(){
    var addTaskButton = $("#add-task");
    addTaskButton.click(function () {

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

    $('.input-group.date').datepicker({
        format: "dd/M/yyyy",
        todayHighlight: true
    });

    $(".select2-multiple").select2();

});
function toggle() {
    var id="create-task";
    var taskCard=document.getElementById("task-card");
    var state = document.getElementById(id).style.display;
    if (state != 'none') {
        document.getElementById(id).style.display = 'none';
        document.getElementById(id).style.width='1%';
        taskCard.style.width='70%';
        taskCard.style.display='inline-block';
    } else {
        if($(window).width() < 768 ){
            taskCard.style.width='1%';
            taskCard.style.display='none';
            document.getElementById(id).style.display = 'inline-block';
            document.getElementById(id).style.width='70%';
        }else{
            document.getElementById(id).style.display = 'inline-block';
            document.getElementById(id).style.width='40%';
            taskCard.style.width='40%';
        }


    }
}
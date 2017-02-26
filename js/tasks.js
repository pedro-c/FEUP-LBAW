/**
 * Created by pedroc on 26/02/17.
 */

$(document).ready(function(){
    var tasks = $("#task-title");
    tasks.click(function() {
        var id="create-task";
        var taskCard=document.getElementById("task-card");
        var state = document.getElementById(id).style.display;
        if (state != 'none') {
            document.getElementById(id).style.display = 'none';
            taskCard.style.width='70%';
        } else {
            document.getElementById(id).style.display = 'inline-block';
            document.getElementById(id).style.width='40%';
            taskCard.style.width='40%';

        }
    });

});

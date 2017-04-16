$(document).ready(function(){

    var addTaskButton = $(".task-button");

    addTaskButton.click(function () {

        var clickBtnValue = $(this).val();
        console.log(clickBtnValue);
        var ajaxurl = 'tasks.php',
            data =  {'action': clickBtnValue};
        $.post(ajaxurl, data, function () {
            // Response div goes here.
            alert("action performed successfully");
        });

    });

    $('.input-group.date').datepicker({
        format: "dd/M/yyyy",
        todayHighlight: true
    });

    $('.select2-multiple').select2();

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
        document.getElementById('mobile-back').style.display='none';
    } else {
        if($(window).width() < 768 ){
            taskCard.style.width='1%';
            taskCard.style.display='none';
            document.getElementById(id).style.display = 'inline-block';
            document.getElementById(id).style.width='70%';
            document.getElementById('mobile-back').style.display='inline-block';
        }else{
            document.getElementById(id).style.display = 'inline-block';
            document.getElementById(id).style.width='40%';
            taskCard.style.width='40%';
            document.getElementById('mobile-back').style.display='none';
        }


    }
}
$(document).ready(function(){

    var addTaskButton = $(".task-button");

   $('.uncompleted').show();
   $('.completed').hide();

    addTaskButton.click(function () {

        var clickBtnValue = $(this).val();
        console.log(clickBtnValue);
        var ajaxurl = '../api/tasks/create-task.php',
            data =  {'action': clickBtnValue};
        $.post(ajaxurl, data, function (response) {
            var data = JSON.parse(response);
            console.log(data);
            var tasklist = document.getElementById('task-list');
            var row = tasklist.insertRow();
            row.setAttribute("class", "task");
            row.setAttribute("id", data[0].id);
            var cell1 = row.insertCell(0);
            var cell2 = row.insertCell(1);
            var cell3 = row.insertCell(2);
            cell1.innerHTML = "<i class='fa fa-check-circle-o' id='complete-button' onclick='completeTask("+data[0].id+")'></i>";
            cell2.innerHTML = "<div><textarea onclick='toggle("+data[0].id+");' id="+data[0].id+">New Task</textarea></div>";
            cell3.innerHTML = "<i id='delete-button' onclick='deleteTask("+data[0].id+")' name='delete-task' class='fa fa-times'></i>";
        });

    });

    $('.input-group.date').datepicker();

    $('.select2-multiple').select2({
        tags: true
    });

    $('.select2-single').select2({
        maximumSelectionLength: 1
    });


    $("#task-name").keyup(function(e) {

        var m=$("#task-name");
        var value= m.val();
        var taskId = $("#task-name").attr("name");
        $("#"+taskId+".task-name").val(value);
    });

    $(".select2").on('focusout', function() {


        $.ajax({
            type:'post',
            url: '../api/tasks/assign-task.php',
            data:  {'taskAssign': $("#task-assign option:selected").val(), 'taskId': $("#task-name").attr("name")},
            success: function() {

                console.log($("#task-assign option:selected").val());

            }

        });

    });

    $("#task-name").focusout(function(e) {

        $.ajax({
            type:'post',
            url: '../api/tasks/change-task-name.php',
            data:  {'taskName': $("#task-name").val() , 'taskId': $("#task-name").attr("name")},
            success: function() {

                console.log("done");

            }

        });

    });

    $("#task-deadline-date").focusout(function(e) {

        $.ajax({
            type:'post',
            url: '../api/tasks/set-task-deadline.php',
            data:  {'taskDeadline': $("#task-deadline-date").val()+" "+$("#task-deadline-time").val() , 'taskId': $("#task-name").attr("name")},
            success: function() {
                console.log($("#task-deadline-date").val()+" "+$("#task-deadline-time").val());
            }

        });

    });

    $("#task-deadline-time").focusout(function(e) {

        $.ajax({
            type:'post',
            url: '../api/tasks/set-task-deadline.php',
            data:  {'taskDeadline': $("#task-deadline-date").val()+" "+$("#task-deadline-time").val() , 'taskId': $("#task-name").attr("name")},
            success: function() {
                console.log($("#task-deadline-date").val()+" "+$("#task-deadline-time").val());
            }

        });
    });

    $("#task-description").focusout(function(e){
        $.ajax({
            type:'post',
            url: '../api/tasks/change-task-description.php',
            data:  {'taskDescription': $("#task-description").val() , 'taskId': $("#task-name").attr("name")},
            success: function() {
                console.log("description: " + $("#task-description").val());
                console.log("id: " + $("#task-name").attr("name"));

            }

        });
    });

    $("#task-tags").focusout(function(e){
        $.ajax({
            type:'post',
            url: '../api/tasks/set-task-tags.php',
            data:  {'taskTags':  $("#task-assign option:selected").val() , 'taskId': $("#task-name").attr("name")},
            success: function() {
                console.log($("#task-assign option:selected").val());
                console.log("id: " + $("#task-name").attr("name"));

            }

        });
    });

    $("#add-comment-btn").click(function(e){
        if($("#comment-content").val() != ""){
            $.ajax({
                 type:'post',
                 url: '../api/tasks/add-task-comment.php',
                 data:  {'taskComment': $("#comment-content").val() , 'taskId': $("#task-name").attr("name")},
                 success: function() {
                     console.log($("#comment-content").val(""));
                 }

             });

            $.ajax({
                type:'post',
                url: '../api/tasks/get-task-comments.php',
                data:  {'taskId': $("#task-name").attr("name")},
                success: function(request) {
                    var response = JSON.parse(request);

                    console.log(response);

                    $("#task-comments").html("");
                    for (var i = 0; i < response[0].length; i++) {
                        $("#task-comments").append("<div class='comment-info'><img src='../images/users/"+  response[0][i].photo_path +"' class='img-circle'><h4>" + response[0][i].name + "</h4></div><p>" + response[0][i].creation_date.substring(0,16) + "</p><p>" + response[0][i].content +"</p>");
                    }
                }

            });
        }



    });


});
function toggle(taskId) {

    $.ajax({
        type:'post',
        url: '../api/tasks/task-details.php',
        data:  {'taskId': taskId},
        success: function(request) {
            /*[{"id":312,"name":"New Task","description":null,"deadline":null,"creator_id":119,"assigned_id":null,"completer_id":null,"project_id":31}]*/

            console.log(request);

            var response = JSON.parse(request);

            console.log(response);

            if(response[2][0]!=null){
                $("#task-assign").html("");
                $("#task-assign").append($('<option>', {
                    value: response[2][0].id,
                    text: response[2][0].name,
                    selected: true
                }));
            }

            for (var i = 0; i < response[3].length; i++) {
                $("#task-assign").append($('<option>', {
                    value: response[3][i].id,
                    text: response[3][i].name,
                }));
            }
            if(response[0][0].name != null){
                $("#task-name").val(response[0][0].name);
            }
            $("#task-name").attr("name",taskId);
            if(response[0][0].description != null){
                $("#task-description").val(response[0][0].description);
            }
            if(response[0][0].deadline != null){
                $("#task-deadline-date").attr("value",response[0][0].deadline.split(" ")[0]);
                $("#task-deadline-time").attr("value",response[0][0].deadline.split(" ")[1]);
            }
            $("#task-tags").html("");
            for (var i = 0; i < response[1].length; i++) {
                $("#task-tags").append($('<option>', {
                    value: response[1][i].id,
                    text: response[1][i].name,
                    selected: true
                }));
            }
            for (var i = 0; i < response[5].length; i++) {
                $("#task-tags").append($('<option>', {
                    value: response[5][i].id,
                    text: response[5][i].name,
                    selected: false
                }));
            }


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

            $("#task-comments").html("");
            for (var i = 0; i < response[4].length; i++) {
                $("#task-comments").append("<div class='comment-info'><img src='../images/users/"+  response[4][i].photo_path +"' class='img-circle'><h4>" + response[4][i].name + "</h4></div><p>" + response[4][i].creation_date.substring(0,16) + "</p><p>" + response[4][i].content +"</p>");
            }
        }

    });


}

function deleteTask(taskId) {

    $.ajax({
        type:'post',
        url: '../api/tasks/delete-task.php',
        data:  {'taskId': taskId},
        success: function() {

            $('#'+taskId).remove();

        }

    });
}


function completeTask(taskId) {

    $.ajax({
        type:'post',
        url: '../api/tasks/complete-task.php',
        data:  {'taskId': taskId},
        success: function() {


        }

    });
}

function back() {

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

function showUncompletedTasks() {
    $('.uncompleted').show();
    $('.completed').hide();
}

function showCompletedTasks() {
    $('.uncompleted').hide();
    $('.completed').show();
}
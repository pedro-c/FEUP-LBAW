$(document).ready(function () {


    $(".input-group.date").datepicker({
        format: "dd/M/yyyy",
        todayHighlight: true,
        orientation: "bottom left"
    });

    $(".select2-multiple").select2({
        tags: true,
        maximumSelectionLength: 1
    });

    $(".select2-invite-users").select2();


    $("#hide").click(function () {
        $("p").hide();
    });

    $('i[data-toggle=modal]').click(function () {
        var data_id = '';
        if (typeof $(this).data('id') !== 'undefined')
            data_id = $(this).data('id');

        $("#meeting-id-delete").text(data_id);
    });

    $('#plus').click(function(){$('#add-file').trigger('click'); });

    $('input#add-file').change(function(){
        var files = $(this)[0].files;
        if(files.length > 0){
            $("#file-info").html("You have uploaded " + files.length + " files.");
        }
    });

});

function deleteMeeting() {
    meeting_id = $("#meeting-id-delete").text();

    console.log(meeting_id);

    $.ajax({
        type: 'POST',
        data: { 'meeting_id': meeting_id } ,
        url:'../api/meetings/delete-meeting.php',
        dataType: 'json',
        success: function (data) {
            location.reload();
        }
    });
}


function inviteMoreUsers(meeting_id) {
    var identifier = '#' + meeting_id + 'uninvited-users';
    if($(identifier).is(":hidden"))
        $(identifier).show();
    else $(identifier).hide();
}

function schedule() {
    $("#container_to_collapse").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").addClass("col-lg-6 col-md-6 col-sm-6 hidden-xs");
    $(".meeting-panel").removeClass("col-lg-6 col-md-6 col-sm-6 col-xs-12");
    $(".meeting-panel").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#mobile-back").show();
    $("#container_schedule_meeting").show();
    $("#container_meeting_info").hide();
    $("#schedule_meetings").css("border-bottom","4px solid");
    $("#schedule_meetings").css("border-bottom-color","#e9d460");
    $("#future_meetings").css("border-bottom","none");
    $("#edit-meeting").hide();
}

function exitMobile() {
    $("#mobile-back").hide();
    $("#container_to_collapse").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").removeClass("col-lg-6 col-md-6 col-sm-6 hidden-xs");
    $(".meeting-panel").addClass("col-lg-6 col-md-6 col-sm-6 col-xs-12");
    $(".meeting-panel").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_schedule_meeting").hide();
}

function exit_trash() {
    $("#container_to_collapse").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").removeClass("col-lg-6 col-md-6 col-sm-6 hidden-xs");
    $(".meeting-panel").addClass("col-lg-6 col-md-6 col-sm-6 col-xs-12");
    $(".meeting-panel").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_schedule_meeting").hide();
    $("#container_meeting_info").hide();
    $("#future_meetings").css("border-bottom","4px solid");
    $("#future_meetings").css("border-bottom-color","#e9d460");
    $("#schedule_meetings").css("border-bottom","none");
}

function getFormatImage(format) {
    switch (format){
        case "png":
            return "../images/assets/png.png";
        case "JPG":
            return "../images/assets/png.png";
        case "jpg":
            return "../images/assets/png.png";
        case "pdf":
            return "../images/assets/pdf.png";
        default:
            return "../images/assets/default.png";
    }
}

function downloadFile(file_id) {
    console.log(file_id);

    $.ajax({
        type: 'POST',
        data: { 'file_id': file_id } ,
        url:'../api/meetings/download-file.php',
        dataType: 'json',
        success: function (data) {
            window.location.href = '../actions/meetings/download-file.php?f='+ data[0];
        }
    });

}

function show_Meeting_Info(meeting_id){

    console.log("Show Info");
    console.log(meeting_id);

    $.ajax({
        type: 'POST',
        data: { 'meeting_id': meeting_id} ,
        url:'../api/meetings/meeting-details.php',
        dataType: 'json',
        success: function (data) {

            date = data[0].date.substr(0,data[0].date.indexOf(' '));
            time = data[0].date.substr(data[0].date.indexOf(' ')+1);

            hours = time.substr(0,time.indexOf(':'));
            minutes = time.substr(time.indexOf(':')+1,time.indexOf(':'));

            $("#meeting_duration").html("Approximately " + data[0].duration + " minutes");
            $("#meeting_title").html(data[0].name);
            $("#meeting_description").html(data[0].description);
            $("#meeting_time").html(hours + ":" + minutes + "h ");
            $("#meeting_date").html(date);

        }
    });

    $.ajax({
        type: 'POST',
        data: { 'meeting_id': meeting_id} ,
        url:'../api/meetings/meeting-attendees.php',
        dataType: 'json',
        success: function (data) {

            $("#guest_div").html(" ");
            var i;
            for(i = 0; i< data.length; i++){

                if(data[i].photo_path == null)
                    var path = '../images/users/default_image_profile1.jpg';
                else path = '../images/users/' + data[i].photo_path;

                $("#guest_div").append("<div class='user-name' style='display: inline-block; padding-bottom: 10px;'><img style='border-radius: 50%; ' class='user_photo' src=" + path + " ><label style='padding-left: 5px; font-weight: normal; padding-top: 5px;'>" + data[i].name + "</label></div><br>")
            }
        }
    });

    $.ajax({
        type: 'POST',
        data: { 'meeting_id': meeting_id} ,
        url:'../api/meetings/meeting-files.php',
        dataType: 'json',
        success: function (data) {

            $("#meeting_files").html(" ");
            var i;
            for(i = 0; i< data.length; i++){

                var format = data[i].name.substr(data[i].name.length - 3);
                $("#meeting_files").append(" <div class='file' style='padding-bottom: 7px'><img class='file_show'" +  "src=" + getFormatImage(format) +"><a style='font-size: small;' id=" + data[i].id + " class='file_description' onclick='downloadFile(" + data[i].id + ")' >" +  data[i].name + "</a></div>");
            }

        }
    });

    $("#container_to_collapse").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").addClass("col-lg-6 col-md-6 col-sm-6 hidden-xs");
    $(".meeting-panel").removeClass("col-lg-6 col-md-6 col-sm-6 col-xs-12");
    $(".meeting-panel").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#mobile-back").show();
    $("#container_schedule_meeting").hide();
    $("#container_meeting_info").show();

}

function changeMeetingTagName(tag_name){

    $("#tag-name").html(tag_name).append('<span class="caret"></span>');

    if(tag_name == 'All'){
        $('.tag-name').each(function(i, obj) {
            $(this).parents('.meeting-panel').show();
        });
    }
    else{
        $('.tag-name').each(function(i, obj) {
            var name = "#"+tag_name;
            if($(this).text() != name)
                $(this).parents('.meeting-panel').hide();
            else
                $(this).parents('.meeting-panel').show();

        });
    }
}


function showUserInfo(user_id){
    console.log("user_id " + user_id);
}


function editMeetingInfo(meeting_id){

    console.log(meeting_id);
    schedule();

    $(".atendees").hide();
    $(".input-group.task-tags").hide();
    $(".box").hide();
    $("#edit-meeting").show();
    $("#submit").hide();

    $.ajax({
        type: 'POST',
        data: { 'meeting_id': meeting_id} ,
        url:'../api/meetings/meeting-details.php',
        dataType: 'json',
        success: function (data) {
            date = data[0].date.substr(0,data[0].date.indexOf(' '));
            time = data[0].date.substr(data[0].date.indexOf(' ')+1);

            $("#meeting-date-id").attr('value', date);
            $("#meeting-duration-id").attr('value', data[0].duration);
            $("#meeting-time-id").attr('value', time);
            $("#meeting-title-id").attr('placeholder', data[0].name);
            $("#meeting-description-id").html(data[0].description);

        }
    });



}
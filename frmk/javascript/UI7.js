$(document).ready(function () {


    $('.input-group.date').datepicker({
        format: "dd/M/yyyy",
        todayHighlight: true,
        orientation: "bottom left"
    });

    $(".select2-multiple").select2();



});

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

function show_Meeting_Info(meeting_id){

    console.log("Show Info");
    console.log(meeting_id);

    $("#container_to_collapse").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").addClass("col-lg-6 col-md-6 col-sm-6 hidden-xs");
    $(".meeting-panel").removeClass("col-lg-6 col-md-6 col-sm-6 col-xs-12");
    $(".meeting-panel").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#mobile-back").show();
    $("#container_schedule_meeting").hide();
    $("#container_meeting_info").show();


}
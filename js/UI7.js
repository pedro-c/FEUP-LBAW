$(document).ready(function () {


    $('.input-group.date').datepicker({
        format: "dd/M/yyyy",
        todayHighlight: true
    });

    $(".select2-multiple").select2();



});

function schedule() {
    $("#container_to_collapse").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").addClass("col-lg-6 col-md-6 col-sm-6 col-xs-6");
    $(".meeting-panel").removeClass("col-lg-6 col-md-6 col-sm-6 col-xs-12");
    $(".meeting-panel").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_schedule_meeting").show();
}

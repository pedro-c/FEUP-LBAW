$(document).ready(function () {

    $(".select2-multiple").select2();



});

function uploadFile() {

    $("#container_to_collapse").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").addClass("col-lg-6 col-md-6 col-sm-6 hidden-xs ");
    $(".file").removeClass("col-lg-4 col-md-4 col-sm-4 col-xs-12");
    $(".file").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $(".uploadFile_container").show();
    $("#uploadButton").css("border-bottom","4px solid #e9d460");
    $("#goBackButton").css("border","none");
    $("#mobile-back").show();
    $("#container_file_info").hide();

}

function fileInfo() {

    $("#container_to_collapse").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").addClass("col-lg-6 col-md-6 col-sm-6 hidden-xs ");
    $(".file").removeClass("col-lg-4 col-md-4 col-sm-4 col-xs-12");
    $(".file").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_file_info").show();
    $("#uploadButton").css("border-bottom","4px solid #e9d460");
    $("#goBackButton").css("border","none");
    $("#mobile-back").show();

}

function deleteUpload() {

    $("#container_to_collapse").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").removeClass("col-lg-6 col-md-6 col-sm-6 col-xs-6");
    $(".file").addClass("col-lg-4 col-md-4 col-sm-4 col-xs-12");
    $(".file").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $(".uploadFile_container").hide();
    $("#goBackButton").css("border-bottom","4px solid #e9d460");
    $("#uploadButton").css("border","none");
    $("#mobile-back").hide();
    $("#container_file_info").hide();

}

function exitMobile() {
    $("#mobile-back").hide();
    $(".uploadFile_container").hide();
    $("#goBackButton").css("border-bottom","4px solid #e9d460");
    $("#uploadButton").css("border","none");
}

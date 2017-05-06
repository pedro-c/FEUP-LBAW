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

function getFormatImage(format) {
    switch (format){
        case "png":
            return "../images/assets/png.png";
        case "pdf":
            return "../images/assets/pdf.png";
        default:
            return "../images/assets/default.png";
    }
}

function fileInfo(file_id){
    $.ajax({
        type: 'POST',
        data: { 'file_id': file_id} ,
        url:'../api/files/file-details.php',
        dataType: 'json',
        success: function (data) {
            console.log(data[0].name);

            var i;
            for(i=0; i< data.length; i++){
                var format = data[i].name.substr(data[i].name.length - 3);
                $("#format").attr('src', getFormatImage(format));
                $("#file_name").text(data[i].name);
                $("#download_file").attr('onclick','downloadFile('+ data[i].id + ')');
                $("#uploader_id").text(data[i].uploader_id);

                date = data[0].upload_date.substr(0,data[0].upload_date.indexOf(' '));
                time = data[0].upload_date.substr(data[0].upload_date.indexOf(' ')+1);

                $("#upload_date").text(date);
                $("#upload_time").text(time);

            }

        }
    });


    $("#container_to_collapse").removeClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#container_to_collapse").addClass("col-lg-6 col-md-6 col-sm-6 hidden-xs ");
    $(".file").removeClass("col-lg-4 col-md-4 col-sm-4 col-xs-12");
    $(".file").addClass("col-lg-12 col-md-12 col-sm-12 col-xs-12");
    $("#uploadButton").css("border-bottom","4px solid #e9d460");
    $("#goBackButton").css("border","none");
    $("#mobile-back").show();
    $("#container_file_info").show();
    $(".uploadFile_container").hide();

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

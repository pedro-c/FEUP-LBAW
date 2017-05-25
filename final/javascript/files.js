$(document).ready(function () {

    $(".select2-multiple").select2({
        tags: true,
        maximumSelectionLength: 1
    });

    $("#mobile-back").click(function () {
        $("#container_file_info").hide();
        $(".uploadFile_container").hide();
    });

    var width = $(window).width();
    $(window).resize(function () {
        if (width <= '720px') {
            $('.uploadFile_container').addClass('nopadding');
        }
    });

    $( "#drag-here" ).bind( "dragover", function() {
        console.log("dragover");
        $("#here").className = "box drag-here text-center dragover";
        return false;
    });

    $('i[data-toggle=modal]').click(function () {
        var data_id = '';
        if (typeof $(this).data('id') !== 'undefined')
            data_id = $(this).data('id');

        $("#file-id-delete").text(data_id);
    });

    $('#plus').click(function(){$('#add-file-files').trigger('click'); });

    $('input#add-file-files').change(function(){
        var files = $(this)[0].files;
        console.log(files);
        if(files.length > 0){
            $("#file-info-files").html("File uploaded.");
        }
    });

});

function deleteFile(){
    file_id = $("#file-id-delete").text();

    $.ajax({
        type: 'POST',
        data: { 'file_id': file_id } ,
        url:'../api/files/delete-file.php',
        dataType: 'json',
        success: function (data) {
            console.log(data);
            location.reload();
        }
    });

}

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
        case "jpg":
            return "../images/assets/png.png";
        case "JPG":
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
            console.log(data[0]);

            var i;
            for(i=0; i< data.length; i++){
               var format = data[i].file_name.substr(data[i].file_name.length - 3);
                console.log("Format " + format);
                $("#format").attr('src', getFormatImage(format));
                $("#file_name").text(data[i].file_name);
                $("#download_file").attr('onclick','downloadFile('+ data[i].id + ')');
                $("#uploader_id").text(data[i].uploader_name);

                date = data[0].upload_date.substr(0,data[0].upload_date.indexOf(' '));
                time = data[0].upload_date.substr(data[0].upload_date.indexOf(' ')+1);
                hours = time.substr(0,5);

                $("#upload_date").text(date);
                $("#upload_time").text(hours + "h");

                $("#user_photo").attr('src','../images/users/'+ data[i].photo_path);

            }

        }
    });

    $.ajax({
        type: 'POST',
        data: { 'file_id': file_id} ,
        url:'../api/files/file-tag.php',
        dataType: 'json',
        success: function (data) {
            $("#tag_info").html(" ");

            if(data != null)
                $("#tag_info").text('#' + data);
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
    $("#container_to_collapse").removeClass("col-lg-6 col-md-6 col-sm-6 col-xs-6 hidden-xs");
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

function changeTagName(tag_name){


    $("#tag-name").html(tag_name).append('<span class="caret"></span>');

    if(tag_name == 'All'){
        $('.hastag.pull-right').each(function(i, obj) {
                $(this).parents('.file').show();
        });
    }
    else{
        $('.hastag.pull-right').each(function(i, obj) {
            var name = "#"+tag_name;
            if($(this).text() != name)
                $(this).parents('.file').hide();
            else
                $(this).parents('.file').show();
        });
    }
}


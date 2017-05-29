<?php
include_once "common/header.php";
?>

<link href="../css/files.css" rel="stylesheet">
<script src="../javascript/files.js"></script>
<script src="../javascript/meetings.js"></script>

<div class="files_pages">
    <div class="row">
        <div class="col-xs-12">
            <div class="files_title text-center">
                <button id="goBackButton" onclick="deleteUpload()">Files</button>
                <button id="uploadButton" onclick="uploadFile()">Upload New File</button>
            </div>
        </div>
    </div>

    <div class="container files_list">
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                <div id="button-upload" class="col-lg-6 col-md-6 col-sm-6 col-xs-6 button_upload">
                    <button class="uploadFile" onclick="uploadFile()">Upload a File</button>
                </div>
                <div class="col-lg-6 col-md-6 col-sm-6 col-xs-6 button_upload pull-right">
                    <div class="drop-down">
                        <button id="tag-name" class="dropdown-toggle uploadFile" type="button" data-toggle="dropdown">Tag
                            <span class="caret"></span></button>
                        <ul class="dropdown-menu">
                            <li><a id="tag-name-dropwdown" onclick="changeTagName('All')">All</a></li>
                            {foreach $tags as $tag}
                                <li><a id="tag-name-dropwdown" onclick="changeTagName('{$tag}')">{$tag}</a></li>
                            {/foreach}

                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div id="container_to_collapse" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <div class="row">

                {foreach $files as $file}

                    {assign var="format" value=$file.name}
                    {$uploaderName = getUserNameById($file.uploader_id)}
                    {$tag = getFileTag($file.id)}

                <div class="file col-lg-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading" onclick="fileInfo({$file.id})">
                            <div class="file_details">
                                {if {$format|substr:-3} eq "png"}
                                     {$image = "../images/assets/png.png"}
                                {elseif {$format|substr:-3} eq "pdf"}
                                     {$image = "../images/assets/pdf.png"}
                                {elseif {$format|substr:-3} eq "jpg"}
                                    {$image = "../images/assets/png.png"}
                                {elseif {$format|substr:-3} eq "JPG"}
                                    {$image = "../images/assets/png.png"}
                                {else}
                                    {$image = "../images/assets/default.png"}
                                {/if}
                                <img class="file_show" src={$image}>
                                <label class="file_description">{$file.name|truncate:28}</label>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="minutes">
                                {$date = get_day_name($file.upload_date)}
                                <span>{$date} at </span>
                                <span>{$file.upload_date|substr:11|truncate:5:""}</span>
                                <span onclick="changeTagName('{$tag}')" class="hastag pull-right">{if {$tag} != null}#{$tag}{/if}</span>
                            </div>
                            <div class="name">
                                <span>{$uploaderName}</span>
                                <i class="pull-right fa fa-download" aria-hidden="true" onclick="downloadFile({$file.id})"></i>
<!-- Lixo -->                   <i class="pull-right fa fa-times" aria-hidden="true" data-toggle="modal" data-id={$file.id} data-target="#deleteFileModal"></i>
                            </div>

                            <div id="deleteFileModal" class="modal fade" role="dialog">
                                <div class="modal-dialog modal-sm">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close"
                                                    data-dismiss="modal">&times;</button>
                                            <h4 class="modal-title">Delete File</h4>
                                        </div>
                                        <div class="modal-body">
                                            <p class="info-extra">You are allowed to delete this file because you
                                                are one team coordinator.</p>
                                            <p>Are you sure you want to delete this file?</p>
                                            <span id="file-id-delete" hidden></span>
                                        </div>
                                        <div class="modal-footer">
                                            <button id="#accept_button" type="button" class="btn btn-default" data-dismiss="modal" onclick="deleteFile()">Yes
                                            </button>
                                            <button id="#cancel_button" type="button" class="btn btn-default" data-dismiss="modal">No
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
                {/foreach}
            </div>
        </div>

        <div class="uploadFile_container" hidden>
            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                <div class="panel panel-default meeting">
                    <div class="panel-heading">
                        <span>Upload File</span><span class="trash pull-right glyphicon glyphicon-trash hidden-xs"
                                                      aria-hidden="true" onclick="deleteUpload()" ></span>
                    </div>
                    <div class="panel-body">

                        <form action="../actions/files/upload-file.php" method="post" enctype="multipart/form-data">
                        <div id="drag-here" class="box drag-here text-center">
                            <input id="add-file-files" class="box__file" name="file[]" type="file"/><br />
                            <a id="plus"> <span class="glyphicon glyphicon-plus img-responsive"></span></a>
                            <span id="file-info-files"></span>
                        </div>

                        <div class="input-group task-tags ">
                            <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                            <select name="tagOption" class="select2-multiple form-control" multiple="multiple">
                                {foreach $tags as $tag}
                                <option value={$tag}>{$tag}</option>
                                {/foreach}
                            </select>
                        </div>


                        <div class="text-center">
                            <input id="submit" type="submit" value="Submit">
                        </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div id="container_file_info" hidden>
            <div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-lg-10 col-md-10 col-sm-10 col-xs-10" >
                                <div class="file">
                                    <img id="format" class="file_show" src="../images/assets/excel.png">
                                    <div id="file_name" class="title"></div>
                                </div>
                            </div>
                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                <div class="button_back hidden-xs">
                                    <button class="back" onclick="deleteUpload()">
                                        <span id="trash" class="glyphicon glyphicon-arrow-left" aria-hidden="true"></span>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="info-file">
                            <div class="row">
                                <div class="col-lg-8 col-md-8 col-sm-8 col-xs-8">
                                    <div id="user">
                                        <img id="user_photo" src="../images/users/avatar1.png">
                                        <div id="uploader_id" class="name"></div>
                                    </div>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <div class="extra_info">
                                        <span id="tag_info" class="hastag"></span>
                                        <div id="upload_date" class="date"></div>
                                        <div id="upload_time" class="minutes"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="button_download">
                            <button id="download_file" class="download"><i class="fa fa-download" aria-hidden="true"></i>
                                Download File
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="mobile-back" class="hidden-lg hidden-md hidden-sm navbar navbar-default navbar-fixed-bottom"
         onclick="exitMobile()" hidden><h4>« Back</h4></div>
</div>
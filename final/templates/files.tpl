<?php
include_once "common/header.php";
?>

<link href="../css/UI5.css" rel="stylesheet">
<script src="../javascript/UI5.js"></script>
<script src="../javascript/UI7.js"></script>

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
        <div class="text-center button_upload">
            <button class="uploadFile" onclick="uploadFile()">Upload a File</button>
        </div>

        <div id="container_to_collapse" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <div class="row">

                {foreach $files as $file}

                    {assign var="format" value=$file.name}
                    {$uploaderName = getUserNameById($file.uploader_id)}


                <div class="file col-lg-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading" onclick="fileInfo({$file.id})">
                            <div class="file_details">
                                {if {$format|substr:-3} eq "png"}
                                {$image = "../images/assets/png.png"}
                                {elseif {$format|substr:-3} eq "pdf"}
                                {$image = "../images/assets/pdf.png"}
                                {else}
                                {$image = "../images/assets/default.png"}
                                {/if}
                                <img class="file_show" src={$image}>
                                <label class="file_description">{$file.name|truncate:36}</label>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="minutes">
                                <span>3 minutes ago</span>
                                <span class="hastag -rightpull">#TAG</span>
                            </div>
                            <div class="name">
                                <span>{$uploaderName}</span>
                                <i class="pull-right fa fa-download" aria-hidden="true" onclick="downloadFile({$file.id})"></i>
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
                        <span>Upload File</span><span class="trash pull-right glyphicon glyphicon-trash"
                                                      aria-hidden="true" onclick="deleteUpload()"></span>
                    </div>
                    <div class="panel-body">

                        <form action="file-upload.php" method="post" enctype="multipart/form-data">
                        <div class="box drag_here text-center hidden-xs">
                            <div>
                                <br>
                                <span class="glyphicon glyphicon-plus"></span>
                                <br>
                                <span class="info"> Drag Files Here </span>
                                <br><br>
                                <input name="files[]" type="file" /><br />
                                <input class="btn btn-default" type="submit" value="Upload Files" />
                            </div>
                        </div>

                        <div class="input-group task-tags">
                            <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                            <select class="select2-multiple form-control" multiple="multiple">
                                {foreach $tags as $tag}
                                <option value={$tag.id}>{$tag.name}</option>
                                {/foreach}
                            </select>
                        </div>
                        </form>

                        <div class="text-center">
                            <input id="submit" type="submit" value="Submit" style="margin-top: 20px;">
                        </div>
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
                                    <div id="file_name" class="title">O</div>
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
                                        <span class="hastag">#general</span>
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
</div>

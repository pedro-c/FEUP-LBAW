<?php
include_once "common/header.html";
?>

<link href="../css/UI5.css" rel="stylesheet">
<script src="../js/UI5.js"></script>

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
                <div class="file col-lg-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading" onclick="fileInfo()">
                            <div class="file_details">
                                <img class="file_show" src="../assets/excel.png">
                                <label class="file_description"> Meeting_SummerInternship_2018 </label>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="minutes">
                                <span>3 minutes ago</span>
                                <span class="hastag -rightpull">#general</span>
                            </div>
                            <div class="name">
                                <span>Edgar Passos</span>
                                <i class="pull-right fa fa-download" aria-hidden="true"></i>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="file col-lg-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading" onclick="fileInfo()">
                            <div class="file_details">
                                <img class="file_show" src="../assets/pdf.png">
                                <label class="file_description"> Meeting_4_Abr </label>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="minutes">
                                <span>10 minutes ago</span>
                                <span class="hastag pull-right">#design</span>
                            </div>
                            <div class="name">
                                <span>Maria João Mira Paulo</span>
                                <i class="pull-right fa fa-download" aria-hidden="true"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="file col-lg-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading" onclick="fileInfo()">
                            <div class="file_details">
                                <img class="file_show" src="../assets/file.png">
                                <label class="file_description"> TimeTable_New </label>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="minutes"><span>30 minutes ago</span>
                                <span class="hastag pull-right">#general</span></div>
                            <div class="name">
                                <span>Zé Carlos</span>
                                <i class="pull-right fa fa-download" aria-hidden="true"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="file col-lg-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading" onclick="fileInfo()">
                            <div class="file_details">
                                <img class="file_show" src="../assets/ppt.png">
                                <label class="file_description"> Details_Meeting5 </label>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="minutes">
                                <span>60 minutes ago</span>
                                <span class="hastag pull-right">#general</span>
                            </div>
                            <div class="name">
                                <span>Maria João Mira Paulo</span>
                                <i class="pull-right fa fa-download" aria-hidden="true"></i>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="file col-lg-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading">
                            <div class="file_details">
                                <img class="file_show" src="../assets/excel.png">
                                <label class="file_description"> Meeting_4_Abr </label>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="minutes">
                                <span>1 day ago</span>
                                <span class="hastag pull-right">#design</span>
                            </div>
                            <div class="name">
                                <span>Edgar Passos</span>
                                <i class="pull-right fa fa-download" aria-hidden="true"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="file col-lg-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading">
                            <div class="file_details">
                                <img class="file_show" src="../assets/word.png">
                                <label class="file_description"> Project_ITK </label>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="minutes"><span>7 days ago</span>
                                <span class="hastag pull-right">#general</span></div>
                            <div class="name">
                                <span>Pedro Costa</span>
                                <i class="pull-right fa fa-download" aria-hidden="true"></i>
                            </div>
                        </div>
                    </div>
                </div>
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

                        <div class="box drag_here text-center hidden-xs">
                            <div>
                                <span class="glyphicon glyphicon-plus"></span>
                                <br>
                                <span class="info"> Drag Files Here </span>
                            </div>
                        </div>

                        <div class="input-group task-tags">
                            <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                            <select class="select2-multiple form-control" multiple="multiple">
                                <option value="M">Marketing</option>
                                <option value="L">Logistics</option>
                                <option value="S">Sponsors</option>
                            </select>
                        </div>

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
                                    <img class="file_show" src="../assets/excel.png">
                                    <div class="title">Meeting SummerInternship_2018</div>
                                </div>
                            </div>
                            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2">
                                <div class="button_back hidden-xs">
                                    <button class="back">
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
                                        <img id="user_photo" src="../assets/avatar2.png">
                                        <div class="name">Pedro Duarte da Costa</div>
                                    </div>
                                </div>
                                <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
                                    <div class="extra_info">
                                        <span class="hastag">#general</span>
                                        <div class="date">15.04.2018</div>
                                        <div class="minutes">3 minutes ago</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="button_download">
                            <button class="download"><i class="fa fa-download" aria-hidden="true"></i>
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

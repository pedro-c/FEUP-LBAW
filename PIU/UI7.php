<?php
include_once "common/header.html";
?>

<link href="../css/UI7.css" rel="stylesheet">
<script src="../js/UI7.js"></script>

<div id="page-meetings">
    <div class="row">
        <div class="col-xs-12">
            <div class="title_bar text-center">
                <button>Future Meetings</button>
                <button>Past Meetings</button>
                <button>Schedule a Meeting</button>
            </div>
        </div>
    </div>

    <div class="container_meetings">
        <div class="row">
            <div id="container_meetings" class="col-xs-10 col-sm-offset-1">
                <div id="future_meetings">
                    <div class="text-center button_scheduale">
                        <button class="schedule" onclick="schedule()">Schedule Meeting</button>
                    </div>
                    <div class="meetings">
                        <div class="row">
                            <div class="col-xs-5 col-sm-offset-1 specify_padding ">
                                <div class="meeting">
                                    <div class="information_meeting"><br>
                                        <span id="see_more" class="glyphicon glyphicon-zoom-in"
                                              aria-hidden="true"></span>
                                        <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                                        <label class="date">28.02.2018</label><br>
                                        <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                        <label class="hour">7:00PM</label><br>
                                        <label class="description">Discussion about Summer Internships </label><br>
                                        <label class="user_responsible">Maria Joao Mira Paulo</label><br>
                                        <label class="guests">
                                            <img class="user_photo" src="../assets/avatar2.png">
                                            <img class="user_photo" src="../assets/avatar3.png">
                                            <img class="user_photo" src="../assets/avatar4.png">
                                            <img class="user_photo" src="../assets/avatar7.png">
                                            <span id="plus_user" class="glyphicon glyphicon-plus-sign"
                                                  aria-hidden="true"></span>
                                        </label>
                                        <br>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xs-5 specify_padding"
                            ">
                            <div class="meeting">
                                <div class="information_meeting"><br>
                                    <span id="see_more" class="glyphicon glyphicon-zoom-in" aria-hidden="true"></span>
                                    <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                                    <label class="date">30.02.2018</label><br>
                                    <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                    <label class="hour">3:00PM</label><br>
                                    <label class="description">New Interns</label><br>
                                    <label class="user_responsible">Edgar Passos</label><br>
                                    <label class="guests">
                                        <img class="user_photo" src="../assets/avatar3.png">
                                        <img class="user_photo" src="../assets/avatar6.png">
                                        <span id="plus_user" class="glyphicon glyphicon-plus-sign"
                                              aria-hidden="true"></span>
                                    </label>
                                    <br>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-xs-5 col-sm-offset-1 specify_padding ">
                            <div class="meeting">
                                <div class="information_meeting"><br>
                                    <span id="see_more" class="glyphicon glyphicon-zoom-in" aria-hidden="true"></span>
                                    <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                                    <label class="date">03.03.2018</label><br>
                                    <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                    <label class="hour">7:00PM</label><br>
                                    <label class="description">ITK Project</label><br>
                                    <label class="user_responsible">Edgar Passos</label><br>
                                    <label class="guests">
                                        <img class="user_photo" src="../assets/avatar3.png">
                                        <img class="user_photo" src="../assets/avatar6.png">
                                        <img class="user_photo" src="../assets/avatar1.png">
                                        <img class="user_photo" src="../assets/avatar2.png">
                                        <img class="user_photo" src="../assets/avatar4.png">
                                        <span id="plus_user" class="glyphicon glyphicon-plus-sign"
                                              aria-hidden="true"></span>
                                    </label>
                                    <br>
                                </div>
                            </div>
                        </div>

                        <div class="col-xs-5 specify_padding"
                        ">
                        <div class="meeting">
                            <div class="information_meeting"><br>
                                <span id="see_more" class="glyphicon glyphicon-zoom-in" aria-hidden="true"></span>
                                <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                                <label class="date">15.04.2018</label><br>
                                <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                <label class="hour">8:00PM</label><br>
                                <label class="description">Planing new project </label><br>
                                <label class="user_responsible">Pedro Costa</label><br>
                                <label class="guests">
                                    <img class="user_photo" src="../assets/avatar3.png">
                                    <img class="user_photo" src="../assets/avatar6.png">
                                    <img class="user_photo" src="../assets/avatar1.png">
                                    <span id="plus_user" class="glyphicon glyphicon-plus-sign"
                                          aria-hidden="true"></span>
                                </label>
                                <br>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="container_schedule_meeting" hidden>
        <div id="schedule_meeting">
            <div class="button_trash pull-right">
                <button class="trash"><span id="trash" class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                </button>
            </div>
            <div class="form_meeting">
                <form class="new_meeting" method="post" action="" enctype="multipart/form-data">
                    <label class="title">Title: </label>
                    <input class="title" type="text" name="firstname" placeholder="Choose a Creative Title"><br>
                    <div class="col-xs-12" id="create-task-settings">
                        <div class="input-group date">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                            <input type="text" class="form-control">
                        </div>
                        <div class="input-group task-tags">
                            <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                            <select class="select2-multiple form-control" multiple="multiple">
                                <option value="M">Marketing</option>
                                <option value="L">Logistics</option>
                                <option value="S">Sponsors</option>
                            </select>
                        </div>
                    </div>
                   <!-- <label>Meeting Time:</label>
                    <input class="time" type="time" name="lastname" placeholder=""><br>
                    <label>Atendees:</label>
                    <input class="atendees" type="text" name="lastname" placeholder="Add/Remove Participants"><br>
                    <label>Agenda:</label><br>
                    <div class="col-xs-10 col-sm-offset-1">
                        <textarea class="agenda" rows="3" cols="55"></textarea><br>
                    </div>
                    <label>Minutes:</label>
                    <input class="minutes" type="number" name="lastname" placeholder="Duration"><br>-->
                    <label>Important Files:</label>
                    <div class="col-xs-10 box_input text-center col-sm-offset-1">
                        <input class="box_file" type="file" name="files[]" id="file"
                               data-multiple-caption="{count} files selected" multiple/><br><br>
                        <label for="file"><strong>Choose a file</strong><span class=" text-center box_dragndrop"> or drag it here</span>.</label>
                        <br><br><button class="box_button" type="submit">Upload</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</div>
</div>


<?php
include_once "common/footer.html";
?>



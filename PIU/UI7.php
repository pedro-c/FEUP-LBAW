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

    <div class="container_meetings container">
        <div class="text-center button_scheduale">
            <button class="schedule" onclick="schedule()">Schedule Meeting</button>
        </div>
        <div id="container_to_collapse" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <div class="row">
                <div class="meeting-panel col-lg-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading">
                                    <span id="see_more" class="glyphicon glyphicon-chevron-right"
                                          aria-hidden="true"></span>
                            <div class="padding">
                                <i class="fa fa-calendar-o" aria-hidden="true"></i>
                                <label class="date">15.04.2018</label><br>
                                <label class="description">Planing new project </label><br>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="information_meeting"><br>
                                <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                <label class="hour">7:00PM</label><br>
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
                </div>

                <div class="meeting-panel col-lg-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading">
                                    <span id="see_more" class="glyphicon glyphicon-chevron-right"
                                          aria-hidden="true"></span>
                            <div class="padding">
                                <i class="fa fa-calendar-o" aria-hidden="true"></i>
                                <label class="date">15.04.2018</label><br>
                                <label class="description">New Interns - Projects and Resumes </label><br>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="information_meeting"><br>
                                <label class="user_responsible">Maria Joao Mira Paulo</label><br>
                                <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                <label class="hour">7:00PM</label><br>
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
                </div>
            </div>

            <div class="row">
                <div class="meeting-panel col-lg-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading">
                                    <span id="see_more" class="glyphicon glyphicon-chevron-right"
                                          aria-hidden="true"></span>
                            <div class="padding">
                                <i class="fa fa-calendar-o" aria-hidden="true"></i>
                                <label class="date">15.04.2018</label><br>
                                <label class="description">Planing new project </label><br>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="information_meeting"><br>
                                <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                <label class="hour">7:00PM</label><br>
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
                <div class="meeting-panel col-lg-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading">
                                    <span id="see_more" class="glyphicon glyphicon-chevron-right"
                                          aria-hidden="true"></span>
                            <div class="padding">
                                <i class="fa fa-calendar-o" aria-hidden="true"></i>
                                <label class="date">15.04.2018</label><br>
                                <label class="description">New Interns - Projects and Resumes </label><br>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="information_meeting"><br>
                                <label class="user_responsible">Pedro Duarte Costa</label><br>
                                <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                <label class="hour">7:00PM</label><br>
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
                </div>
            </div>
        </div>

        <div id="container_schedule_meeting" class="col-lg-6 col-md-6 col-sm-6 col-xs-12" hidden>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="button_trash">
                        <button class="trash"><span id="trash" class="glyphicon glyphicon-trash"
                                                    aria-hidden="true"></span>
                        </button>
                    </div>
                    <span>Schedule a Meeting</span>
                </div>
                <div class="panel-body">
                    <div class="form-meeting" id="create-meeting-settings">
                        <form class="new_meeting" method="post" action="" enctype="multipart/form-data">
                            <div class="title">
                                <input type="text" class="form-control" placeholder="Choose a creative Title">
                            </div>
                            <div class="calendar">
                                        <span class="meetings_icon glyphicon glyphicon-calendar"
                                              aria-hidden="true"></span>
                                <input type="text" class="form-control" placeholder="Choose a date">
                            </div>
                            <div class="atendees">
                                <span class="meetings_icon glyphicon glyphicon-user" aria-hidden="true"></span>
                                <input type="text" class="form-control" placeholder="Invite Participants">
                            </div>
                            <div class="minutes">
                                <span class="meetings_icon glyphicon glyphicon-time" aria-hidden="true"></span>
                                <input type="number" class="form-control" placeholder="Meeting Duration">
                            </div>

                           <!-- <div class="agenda">
                                <ul>
                                    <li>Write Some Important Tasks</li>
                                    <li>To Do Before the Meeting</li>
                                    <li style="font-size: medium;font-weight: bold">Click Here!</li>
                                </ul>
                                <div class="text-center">
                                    <button>Add More Tasks</button>
                                </div>
                            </div>-->

                            <div class="box drag_here text-center">
                                <div>
                                <span class="glyphicon glyphicon-plus"></span>
                                <br>
                                <span class="info"> Drag Files Here </span>
                                </div>
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



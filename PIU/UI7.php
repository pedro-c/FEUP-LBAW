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
                                    <div class="header">
                                        <span id="see_more" class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                                        <div class="padding">
                                            <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                                            <label class="date" >15.04.2018</label><br>
                                            <label class="description">Planing new project </label><br>
                                        </div>
                                    </div>
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

                            <div class="col-xs-5 specify_padding"
                            ">
                            <div class="meeting">
                                <div class="header">
                                    <span id="see_more" class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                                    <div class="padding">
                                        <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                                        <label class="date">15.04.2018</label><br>
                                        <label class="description">Planing new project </label><br>
                                    </div>
                                </div>
                                <div class="information_meeting"><br>

                                    <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                    <label class="hour">3:00PM</label><br>
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
                                <div class="header">
                                    <span id="see_more" class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                                    <div class="padding">
                                        <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                                        <label class="date">15.04.2018</label><br>
                                        <label class="description">Planing new project </label><br>
                                    </div>
                                </div>
                                <div class="information_meeting"><br>
                                    <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                    <label class="hour">7:00PM</label><br>
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
                            <div class="header">
                                <span id="see_more" class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                                <div class="padding">
                                <span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>
                                <label class="date">15.04.2018</label><br>
                                <label class="description">Planing new project </label><br>
                                </div>
                            </div>
                            <div class="information_meeting"><br>
                                <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                <label class="hour">8:00PM</label><br>
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
            <div class="form-meeting" id="create-meeting-settings">
                <form class="new_meeting" method="post" action="" enctype="multipart/form-data">
                    <div class="title">
                        <input type="text" class="form-control" placeholder="Choose a creative Title">
                    </div>
                    <div class="calendar">
                        <span class="meetings_icon glyphicon glyphicon-calendar" aria-hidden="true"></span>
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

                    <div class="agenda">
                       <ul>
                           <li>Write Some Important Tasks</li>
                           <li>To Do Before the Meeting</li>
                           <li style="font-size: medium;font-weight: bold">Click Here!</li>
                       </ul>
                        <button>Add More Tasks</button>
                    </div>

                </form>
                <!-- <div class="input-group task-tags">
                     <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                     <select class="select2-multiple form-control" multiple="multiple">
                         <option value="M">Marketing</option>
                         <option value="L">Logistics</option>
                         <option value="S">Sponsors</option>
                     </select>
                 </div>-->
            </div>
        </div>
    </div>
</div>


<?php
include_once "common/footer.html";
?>



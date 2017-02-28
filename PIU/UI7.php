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
                                        <span id="see_more" class="glyphicon glyphicon-zoom-in" aria-hidden="true"></span>
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
                                            <span id="plus_user" class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
                                        </label>
                                        <br>
                                    </div>
                                </div>
                            </div>

                            <div class="col-xs-5 specify_padding"">
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
                                        <span id="plus_user" class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
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
                                        <span id="plus_user" class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
                                    </label>
                                    <br>
                                </div>
                            </div>
                        </div>

                        <div class="col-xs-5 specify_padding"">
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
                                    <span id="plus_user" class="glyphicon glyphicon-plus-sign" aria-hidden="true"></span>
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
            <div class="text-center button_trash">
                <button class="trash"> <span id="trash" class="glyphicon glyphicon-trash" aria-hidden="true"></span></button>
            </div>
            <div class="form_meeting">
                <form class="new_meeting">
                    <label>Title: </label>
                    <input class="title" type="text" name="firstname" placeholder="Creative Review"><br>
                    <label>Meeting Date:</label>
                    <input class="date" type="date" name="lastname" placeholder="Choose a Date"><br>
                    <label>Meeting Time:</label>
                    <input class="time" type="time" name="lastname" placeholder=""><br>
                    <label>Atendees:</label>
                    <input class="atendees" type="text" name="lastname" placeholder="Add/Remove Participants"><br>
                    <label>Agenda:</label>
                    <input class="agenda" type="text" name="lastname" placeholder="Important Points"><br>
                    <label>Minutes:</label>
                    <input class="minutes" type="number" name="lastname" placeholder="Duration"><br>
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



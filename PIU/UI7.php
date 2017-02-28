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
                    <button onclick="schedule()">Schedule Meeting</button>
                    <div class="meetings">
                        <div class="row">
                            <div class="col-xs-6 specify_padding">
                                <div class="meeting text-center">
                                    <label class="date">28.02.2018</label><br>
                                    <label class="hour">7:00PM</label><br>
                                    <label class="description">Discussion about Summer Internships </label><br>
                                    <label class="guests"></label>
                                </div>
                            </div>

                            <div class="col-xs-6 specify_padding"">
                                <div class="meeting text-center">
                                    <label class="date">28.02.2018</label><br>
                                    <label class="hour">9:00PM</label><br>
                                    <label class="description">Discussion about Summer Internships </label><br>
                                    <label class="guests"></label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="container_schedule_meeting" hidden>
                <div id="schedule_meeting">
                    <button>Schedule Meeting</button>
                </div>
            </div>
        </div>
    </div>
</div>


<?php
include_once "common/footer.html";
?>



<link href="../css/UI7.css" rel="stylesheet">
<script src="../javascript/UI7.js"></script>

<div id="page-meetings">
    <div class="row">
        <div class="col-xs-12">
            <div class="title_bar text-center">
                <button id="future_meetings" onclick="exit_trash()">Future Meetings</button>
                <button id="schedule_meetings" onclick="schedule()">Schedule a Meeting</button>
            </div>
        </div>
    </div>

    <div class="container_meetings container">
        <div class="text-center button_scheduale">
            <button class="schedule" onclick="schedule()">Schedule Meeting</button>
        </div>
        <div id="container_to_collapse" class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
            <div class="row">
            {foreach $meetings as $meeting}

                {$creatorName = getUserNameById($meeting.id_creator)}
                {$time = getTimeFromTimestamp($meeting.date)}
                {$date = getDateFromTimestamp($meeting.date)}

                <div class="meeting-panel col-lg-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="panel panel-default meeting">
                        <div class="panel-heading" onclick="show_Meeting_Info({$meeting.id})">
                            <div class="padding">
                                <i class="fa fa-calendar-o" aria-hidden="true"></i>
                                <label class="date">{$date}</label><br>
                                <label class="description">{$meeting.name} </label><br>
                            </div>
                            <div class="align_middle">
                                <span id="see_more" class="glyphicon glyphicon-chevron-right"
                                      aria-hidden="true" onclick="show_Meeting_Info()"></span>
                            </div>
                        </div>
                        <div class="panel-body">
                            <div class="information_meeting"><br>
                                <span class="glyphicon glyphicon-time" aria-hidden="true"></span>
                                <label class="hour">{$time}</label><br>
                                <label class="user_responsible">{$creatorName}</label><br>
                                <label class="guests">

                                    {$invited_users = getInvitedUsers($meeting.id)}
                                    {$notInvitedmembers = getNonInvitedUser($meeting.id, $project)}
                                    {$coordinator = getMemberStatus($user_aut, $project)}
                                    {$creator = isMeetingCreator($meeting.id, $user_aut)}


                                    {$photos = getInvitedUsersPhotos($meeting.id)}

                                    {foreach $photos as $photo}

                                    <img class="user_photo" style="border-radius: 50%;" src={$photo}>

                                    {/foreach}

                                    {if $coordinator == 'true' || $creator == 'true' }

                                        <span id="plus_user" class="glyphicon glyphicon-plus-sign"
                                              aria-hidden="true" style="border-radius: 50%;" onclick="inviteMoreUsers({$meeting.id})">
                                        </span>
                                        <div id='{$meeting.id|cat:'uninvited-users'}' class="uninvited-users" hidden>

                                            <select name="uninvited_users[]" class="select2-multiple form-control" multiple="multiple" multiple>
                                                {foreach $notInvitedmembers as $notInvitedmember}
                                                    {$name = getUserNameById($notInvitedmember)}
                                                    <option value={$notInvitedmember}>{$name}</option>
                                                {/foreach}
                                            </select>
                                            <input id="submit_invite" type="submit" value="Invite" style="margin-top: 20px;">
                                        </div>
                                    {/if}


                                </label>
                                <br>
                            </div>
                        </div>
                    </div>
                </div>
            {/foreach}
            </div>

        </div>
        <div id="container_schedule_meeting" class="col-lg-6 col-md-6 col-sm-6 col-xs-12" hidden>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="button_trash">
                        <button class="trash" onclick="exit_trash()"><span id="trash" class="glyphicon glyphicon-trash"
                                                                           aria-hidden="true"></span>
                        </button>
                    </div>
                    <span>Schedule a Meeting</span>
                </div>
                <div class="panel-body">
                    <div class="form-meeting" id="create-meeting-settings">
                        <form class="new_meeting" method="post" action="../actions/meetings/scheduleMeeting.php" enctype="multipart/form-data">
                            <div class="title">
                                <input type="text" name="title" class="form-control" placeholder="Choose a Creative Title">
                            </div>
                            <textarea name="description" maxlength="512">Meeting Resume</textarea>

                            <div class="calendar">
                                <span class="input-group-addon meetings_icon glyphicon glyphicon-calendar"
                                      aria-hidden="true"></span>
                                <input type="date" name="date" class="form-control">
                            </div>

                            <div class="time">
                                <span class="meetings_icon glyphicon glyphicon-time" aria-hidden="true"></span>
                                <input type="time" name="time" class="form-control">
                            </div>

                            <div class="atendees">
                                <span class="meetings_icon glyphicon glyphicon-pushpin" aria-hidden="true"></span>
                                <input type="number" name="duration" class="form-control" placeholder="Meeting Duration">
                            </div>

                            <div class="atendees">
                                <span class="meetings_icon glyphicon glyphicon-user" aria-hidden="true"></span>
                                <select name="invited_users[]" class="select2-multiple form-control" multiple="multiple"
                                        placeholder="Invite Participants" multiple>
                                    {foreach $members as $member}

                                        {$memberName = getUserNameById($member['id_user'])}
                                        <option value={$member['id_user']}>{$memberName}</option>
                                    {/foreach}
                                </select>
                            </div>

                            <div class="input-group task-tags ">
                                <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                                <select name="tagOption" class="select2-multiple form-control" multiple="multiple">
                                    {foreach $tags as $tag}
                                        <option value={$tag.id}>{$tag.name}</option>
                                    {/foreach}
                                </select>
                            </div>


                            <div class="box drag_here hidden-xs" ondrop="drop_handler(event);" ondragover="dragover_handler(event);" ondragend="dragend_handler(event);">
                                <input class="box__file" type="file" name="file[]" id="file" multiple />
                                <label for="file"><strong>Choose a file </strong><span class="box__dragndrop"> or drag it here</span>.</label>
                            </div>

                            <div class="text-center">
                                <input id="submit" type="submit" value="Submit" style="margin-top: 20px;">
                            </div>

                            <div class="title">{$errors}</div>

                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div id="container_meeting_info" class="col-lg-6 col-md-6 col-sm-6 col-xs-12" hidden>

            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="button_back hidden-xs">
                        <button class="back" onclick="exit_trash()">
                            <span id="trash" class="glyphicon glyphicon-arrow-left" aria-hidden="true"></span>
                        </button>
                    </div>
                    <span>Meeting Info</span>
                </div>
                <div class="panel-body">
                    <div class="info-meeting" id="create-meeting-settings">
                        <div id="meeting_title" class="title"></div>
                        <div id="meeting_date" class="date"></div>
                        <label id="meeting_time" class="hour"></label>
                        <div id="meeting_description" class="description"></div>
                        <div id="meeting_duration" class="minutes"></div>
                        <div id="meeting_files" class="files"></div>
                        <div id="guest_div" class="guests"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div id="mobile-back" class="hidden-lg hidden-md hidden-sm navbar navbar-default navbar-fixed-bottom"
         onclick="exitMobile()" hidden><h4>« Back</h4></div>
</div>

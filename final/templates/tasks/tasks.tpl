<!-- Custom CSS -->
<link href="../css/tasks.css" rel="stylesheet">
<script src="../javascript/tasks.js"></script>


<div id="page-wrapper">

    <!-- Page Heading -->
    <div class="tasks-body">
        <div class="tasks-nav">
            <button type="button" id="uncompleted-button" class="selected" onclick="showUncompletedTasks()">To-Do</button>
            <button type="button" id="completed-button" onclick="showCompletedTasks()">Completed</button>
        </div>


        <div class="tasks-card" id="task-card">
            <div class="tasks-header">
                <button id="task-button" class="task-button" value="create-task">Add Task</button>
                <div id="tags-dropdown-menu" class="drop-down">
                    <button id="tag-name" class="dropdown-toggle" type="button" data-toggle="dropdown">Tag
                        <span class="caret"></span></button>
                    <ul class="dropdown-menu">
                        <li><a id="tag-name-dropwdown" onclick="changeTagName('All')">All</a></li>
                        {foreach $projectTags as $projectTag}
                            <li><a id="tag-name-dropwdown" onclick="changeTagName('{$projectTag.name}')">{$projectTag.name}</a></li>
                        {/foreach}

                    </ul>
                </div>
            </div>
            <div class="task-content">
                <table class="tasks">
                    <tbody id="task-list">

                    {foreach $tasks as $task}

                        {if $task.completer_id eq ""}
                            {$completed = "uncompleted"}
                        {else}
                            {$completed = "completed"}
                        {/if}


                        {$tag = getTagFromTaskId($task.id)}

                        <tr class="task {$completed}" id="{$task.id}">
                            <td>
                                <i id="complete-button" name="complete-task"  onclick="completeTask({$task.id})" class="fa fa-check-circle-o"></i>
                            </td>
                            <td>
                                <div class="task-name">
                                    <textarea onclick="toggle({$task.id});" id="{$task.id}">{$task.name}</textarea>
                                    {if {$tag[0].name} != null}
                                        <p class="hashtag {$completed}">{$tag[0].name}</p>
                                    {else}
                                        <p style="visibility: hidden;" class="hashtag {$completed}">{$tag[0].name}</p>
                                    {/if}

                                </div>
                            </td>
                            <td>
                                <i id="delete-button" onclick="deleteTask({$task.id})" name="delete-task" class="fa fa-times"></i>
                            </td>
                        </tr>

                    {/foreach}

                    </tbody>
                </table>
            </div>
        </div>
        <div class="tasks-card create-task row" id="create-task" style="display: none">
            <div class="col-xs-12" id="create-task-navbar">
                <div class="col-xs-12" id="assign-to">
                    <img src="../images/users/avatar5.jpg" class="img-circle">
                    <select id="task-assign" class="select2-assign form-control" multiple="single" placeholder="Assign to">

                    </select>
                </div>
            </div>

            <div class="col-xs-12" id="create-task-title">
                <input type="text" id="task-name" placeholder="New Task">
            </div>
            <div class="col-xs-12" id="create-task-settings">
                <div class="input-group">
                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                    <input id="task-deadline-date" type="date" class="form-control">
                    <input id="task-deadline-time" type="time" name="time" class="form-control">
                </div>
                <div class="input-group task-tags">
                    <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                    <select id="task-tags" class="select2-tags form-control" multiple="multiple">
                        {foreach $projectTags as $tag}
                            <option id="{$tag.id}">{$tag.name}</option>
                        {/foreach}
                    </select>
                </div>
            </div>
            <div class="col-xs-12" id="create-task-description">
                <textarea id="task-description"placeholder="Description"></textarea>
            </div>
            <div id="task-comments" class="task-comments col-xs-12">


            </div>
            <div class="add-comment" id="add-comment">
                <img src="../images/users/avatar6.png" class="img-circle">
                <textarea id = "comment-content" placeholder="Write a comment..."></textarea>
                <button id="add-comment-btn" class="btn">Add</button>
            </div>

        </div>
        <div id="mobile-back" class="navbar navbar-default navbar-fixed-bottom" onclick="back()">
            <h4>« Back</h4>
        </div>
    </div>

</div>

<?php
include_once "common/header.html";
?>

<!-- Custom CSS -->
<link href="../css/tasks.css" rel="stylesheet">
<link href="../css/bootstrap-datepicker3.css" rel="stylesheet">
<link href="../css/bootstrap-datepicker.css" rel="stylesheet">
<script src="../js/tasks.js"></script>
<script src="../js/bootstrap-datepicker.js"></script>

<div id="page-wrapper">

        <!-- Page Heading -->
                <div class="tasks-body">
                    <div class="tasks-nav">
                        <button type="button">To-Do</button>
                        <button type="button">Completed</button>
                    </div>


                    <div class="tasks-card" id="task-card">
                        <div class="tasks-header">
                            <button id="add-task">Add Task</button>
                        </div>
                        <div class="task-content">
                            <table class="tasks">
                                <tbody id="task-list">
                                <tr class="task">
                                    <td>
                                        <i class="fa fa-check-circle-o" id="complete-button"></i>
                                    </td>
                                    <td>
                                        <div>
                                            <textarea onclick="toggle();" id="task-title">Tarefa 1</textarea>
                                        </div>
                                    </td>
                                    <td>
                                        <i class="fa fa-times" id="delete-button"></i>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="tasks-card create-task row" id="create-task" style="display: none">
                        <div class="col-xs-12" id="create-task-navbar">
                            <div class="col-xs-12" id="assign-to">
                                <i class="fa fa-user" aria-hidden="true"></i>
                                <textarea placeholder="Assign to" id="task-assign"></textarea>
                            </div>
                            <button class="btn btn-danger" id="delete-button"> Delete </button>
                        </div>

                            <div class="col-xs-12" id="create-task-title">
                                <i class="fa fa-check-circle-o" id="complete-button"></i>
                                <textarea placeholder="New Task"></textarea>
                            </div>
                            <div class="col-xs-12" id="create-task-settings">
                                <div class="input-group date">
                                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                    <input type="text" class="form-control">
                                </div>
                                <i class="fa fa-tag"></i>
                            </div>
                            <div class="col-xs-12" id="create-task-description">
                                <textarea placeholder="Description"></textarea>
                            </div>

                    </div>
                </div>



</div>



<?php
include_once "common/footer.html";
?>



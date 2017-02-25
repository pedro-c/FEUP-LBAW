<?php
include_once "common/header.html";
?>

<!-- Custom CSS -->
<link href="../css/tasks.css" rel="stylesheet">

<div id="page-wrapper">

        <!-- Page Heading -->
                <div class="tasks-body">
                    <div class="tasks-nav">
                        <button type="button">To-Do</button>
                        <button type="button">Completed</button>
                    </div>


                    <div class="tasks-card">
                        <div class="tasks-header">
                            <button>Add Task</button>
                        </div>
                        <div class="task-content">
                            <table class="tasks">
                                <tbody>
                                <tr class="task">
                                    <td>
                                        <i class="fa fa-check-circle-o" id="complete-button"></i>
                                    </td>
                                    <td>
                                        <div>
                                            <textarea>Tarefa 1</textarea>
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
                    <div class="tasks-card create-task">
                        <div id="create-task-navbar">
                            <i class="fa fa-user" aria-hidden="true"></i>
                            <textarea id="task-assign">Assign to</textarea>
                            <button class="btn btn-danger" id="delete-button"> Delete </button>
                        </div>
                        <div>
                            <div id="create-task-title">
                                <i class="fa fa-check-circle-o" id="complete-button"></i>
                                <textarea>Tarefa 1</textarea>
                            </div>
                            <div>
                                <i class="fa fa-calendar"></i>
                                <input type="date" name="deadline">
                                <i class="fa fa-tag"></i>
                            </div>
                            <div>
                                <textarea>Description</textarea>
                            </div>
                        </div>
                    </div>
                </div>



</div>



<?php
include_once "common/footer.html";
?>



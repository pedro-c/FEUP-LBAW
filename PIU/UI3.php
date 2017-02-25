<?php
include_once "common/header.html";
?>

<!-- Custom CSS -->
<link href="../css/tasks.css" rel="stylesheet">7

<div id="page-wrapper">

        <!-- Page Heading -->
                <div class="tasks-body">
                    <div class="">
                        <button type="button" class="btn btn-default navbar-btn">To-Do</button>
                        <button type="button" class="btn btn-default navbar-btn">Completed</button>
                    </div>


                    <div class="tasks-card">
                        <div class="navbar">
                            <button class="btn-warning">Add Task</button>
                        </div>
                        <table class="tasks">
                            <tbody class="tasks">
                            <tr class="task">
                                <div class="task-content">
                                    <td>
                                        <button>Complete</button>
                                    </td>
                                    <td>
                                        <div>
                                            <input type="text" placeholder="Task">
                                        </div>
                                    </td>
                                    <td>
                                        <button>Delete</button>
                                    </td>
                                </div>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="tasks-card create-task">
                        <div class="navbar">
                            <input type="text" placeholder="Assign to">
                            <input type="date" name="deadline">
                            <button class="btn-danger"> Delete </button>
                        </div>
                        <div>
                            <input type="text" placeholder="New Task">
                            <input type="text" placeholder="Description">
                            <input type="text" placeholder="#project">
                        </div>
                    </div>
                </div>



</div>



<?php
include_once "common/footer.html";
?>



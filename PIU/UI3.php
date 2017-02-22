<?php
include_once "common/header.html";
?>

<div id="page-wrapper">

    <div class="container-fluid">

        <!-- Page Heading -->
        <div class="row">
            <div class="col-lg-12 text-center">
                <button type="button" class="btn btn-default navbar-btn">To-Do</button>
                <button type="button" class="btn btn-default navbar-btn">Completed</button>
            </div>


            <div class="col-lg-6">
                <div class="navbar">
                    <button class="btn-warning">Add Task</button>
                </div>
                <table>
                    <tbody>
                        <tr>
                            <td>
                                <button>Complete</button>
                            </td>
                            <td>
                                <div>
                                    <textarea>
                                        Task1
                                    </textarea>
                                </div>
                            </td>
                            <td>
                                <button>Delete</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="col-lg-6">
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
</div>



<?php
include_once "common/footer.html";
?>



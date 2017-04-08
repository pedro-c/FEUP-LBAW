<?php include_once "common/header.php"
?>
<!-- Custom CSS -->
<link href="../../css/forum.css" rel="stylesheet"/>
<div class="page-wrapper container">
    <div class="row"><br>
        <div id="forum-posts" class="list-group">
            <div class="forum-posts-nav">
                <button id="new-post-button" class="list-group-item">
                    <div class="row ">
                        <div id="plus-icon" class="col-lg-1 col-md-1 col-sm-1 col-xs-1">
                            <h4 class="glyphicon glyphicon-plus"></h4>
                        </div>
                        <div id="new-content" class="col-lg-11 col-md-11 col-sm-11 col-xs-11">
                            <h4 class="list-group-item-heading">Write a new post </h4>
                            <div class="list-group-item-text">
                                <small>
                                    <span class="post-submission-date">Create a new discussion</span>
                                </small>
                            </div>
                        </div>
                    </div>
                </button>
                <button class="list-group-item forum-post">
                    <h4 class="list-group-item-heading">Who did this? Like, seriously?!!</h4>
                    <div class="list-group-item-text">
                        <img class="user_photo" src="../../images/users/avatar3.png">
                        <small>
                            <span class="submitter-uname">epassos</span> -
                            <span class="post-submission-date">Feb 23 at 23:31</span>
                        </small>
                    </div>
                </button>
                <button class="list-group-item forum-post">
                    <h4 class="list-group-item-heading">Great PHP resource!</h4>
                    <div class="list-group-item-text">
                        <img class="user_photo" src="../../images/users/avatar4.png">
                        <small>
                            <span class="submitter-uname">jccoutinho</span> -
                            <span class="post-submission-date">Feb 24 at 12:18</span>
                        </small>
                    </div>
                </button>
                <button class="list-group-item forum-post">
                    <h4 class="list-group-item-heading">Deployment Instructions</h4>
                    <div class="list-group-item-text">
                        <img class="user_photo" src="../../images/users/avatar3.png">
                        <small>
                            <span class="submitter-uname">mariajoaomp</span> -
                            <span class="post-submission-date">Feb 12 at 15:12</span>
                        </small>
                    </div>
                </button>
                <button class="list-group-item forum-post">
                    <h4 class="list-group-item-heading">Some requirement changes..</h4>
                    <div class="list-group-item-text">
                        <img class="user_photo" src="../../images/users/avatar2.png">
                        <small>
                            <span class="submitter-uname">pedroc</span> -
                            <span class="post-submission-date">Jan 27 at 00:28</span>
                        </small>
                    </div>
                </button>
                <button class="list-group-item forum-post">
                    <h4 class="list-group-item-heading">Just a heads up!</h4>
                    <div class="list-group-item-text">
                        <img class="user_photo" src="../../images/users/avatar3.png">
                        <small>
                            <span class="submitter-uname">epassos</span> -
                            <span class="post-submission-date">Dec 21 at 8:01</span>
                        </small>
                    </div>
                </button>
                <button class="list-group-item forum-post">
                    <h4 class="list-group-item-heading">Random idea</h4>
                    <div class="list-group-item-text">
                        <img class="user_photo" src="../../images/users/avatar7.png">
                        <small>
                            <span class="submitter-uname">mariajoaomp</span> -
                            <span class="post-submission-date">Dec 20 at 21:01</span>
                        </small>
                    </div>
                </button>
                <nav aria-label="Page navigation">
                    <div class="text-center">
                        <ul class="pagination">
                            <li class="disabled">
                                <a href="#" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            <li class="active"><a href="#">1</a></li>
                            <li><a href="#">2</a></li>
                            <li><a href="#">3</a></li>
                            <li><a href="#">4</a></li>
                            <li><a href="#">5</a></li>
                            <li>
                                <a href="#" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </div>
                </nav>
            </div><!-- forum content -->
        </div>
    </div><!-- row -->
</div>
<script src="../../javascript/forum.js"></script>
<?php include_once "common/footer.html" ?>

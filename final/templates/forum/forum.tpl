<link href="../css/forum.css" rel="stylesheet">

<div class="page-wrapper container">
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

                    <div id="post-listing">
                        <!-- list the posts - to be filled by JS -->
                    </div>

                    <nav aria-label="Page navigation">
                        <div class="text-center">
                            <ul class="pagination">
                                <!-- Will be loaded by JS -->
                            </ul>
                        </div>
                    </nav>
                </div><!-- forum content -->
            </div>
        </div><!-- row -->
    </div>
    <script src="../javascript/forum.js"></script>
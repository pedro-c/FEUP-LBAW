<link href="../../css/forum.css" rel="stylesheet">

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

                    <!-- list the posts -->
                    {foreach $posts as $post}
                        {$user = getUser($post.id_creator)}
                        {$photo = getUserPhoto($user)}
                        <button class="list-group-item forum-post">
                            <span class="post-id" hidden="hidden">{$post.id}</span>
                            <h4 class="list-group-item-heading post-title">{$post.title}</h4>
                            <div class="list-group-item-text post-submitter-info">
                                <img class="submitter-photo" src="{$photo}">
                                <small>
                                    <span class="submitter-uname">{$user.username}</span> -
                                    <span class="post-submission-date">{$post.creation_date}</span>
                                </small>
                            </div>
                        </button>
                    {/foreach}
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
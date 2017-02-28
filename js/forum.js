/**
 * Created by epassos on 2/25/17.
 */
$(document).ready(function(){
    let forum = $("#forum-posts");
    let posts = $(".forum-post");
    let nav = $(".forum-posts-nav");
    let newPostButton = $("#new-post-button");
    let curPost;

    let displayedPosts = [];
    let mobileBack = $(
        '<div id="mobile-back" class="hidden-lg hidden-md hidden-sm navbar navbar-default navbar-fixed-bottom">' +
        '<h4>« Back</h4>' +
        '</div>'
    );
    let postContent = $(
        '<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12">' +
            '<div id="post-content" class="panel panel-primary">' +
                '<div class="panel-heading"><h3 class="panel-title">Post Title</h3>' +
                '<span><a class="glyphicon glyphicon-user"></a> <small>User on 12 Mon at hh:mm</small></span>' +
                '</div>' +
                '<div class="panel-body">Lorem ipsum dolor sit amet, ' +
                    'consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ' +
                    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.' +
                    ' Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.' +
                    ' Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum' +
                '</div>' +
            '</div>' +

            '<ul id="replies" class="list-group">' +
                '<li class="list-group-item">' +
                    '<h5 class="list-group-item-heading"><a class="glyphicon glyphicon-user"></a> <strong>Username</strong></h5>' +
                    '<p class="list-group-item-text">At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.</p>' +
                '</li>' +
                '<li class="list-group-item">' +
                    '<h5 class="list-group-item-heading"><a class="glyphicon glyphicon-user"></a> <strong>Username</strong></h5>' +
                    '<p class="list-group-item-text">Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</p>' +
                '</li>' +
                '<li class="list-group-item">' +
                    '<h5 class="list-group-item-heading"><a class="glyphicon glyphicon-user"></a> <strong>Username</strong></h5>' +
                    '<p class="list-group-item-text">Great idea!</p>' +
                '</li>' +
                '<li class="list-group-item">' +
                    '<h5 class="list-group-item-heading"><a class="glyphicon glyphicon-user"></a> <strong>Username</strong></h5>' +
                    '<p class="list-group-item-text">At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.</p>' +
                '</li>' +
                '<li class="list-group-item">' +
                    '<h5 class="list-group-item-heading"><a class="glyphicon glyphicon-user"></a> <strong>Username</strong></h5>' +
                    '<p class="list-group-item-text">Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</p>' +
                '</li>' +
                '<li class="list-group-item">' +
                    '<h5 class="list-group-item-heading"><a class="glyphicon glyphicon-user"></a> <strong>Username</strong></h5>' +
                    '<p class="list-group-item-text">Great idea!</p>' +
                '</li>' +
            '</ul>' +
        '</div>'
    );

    let newPostPanel = $(
        '<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12">' +
            '<div id="new-post-panel" class="panel panel-primary">' +
                '<div class="panel-heading"><h3 class="panel-title">New Post</h3></div>' +
                '<div class="panel-body">' +
                    '<div class="form-group">' +
                        '<textarea class="form-control" rows="17" id="new-post-text" style="resize: none" placeholder="Write something"></textarea>' +
                    '</div>' +
                    '<button id="submit-new-post" class="btn btn-default btn-form" type="submit">Submit</button>' +
                    '<button id="cancel-new-post" class="btn btn-default btn-form">Cancel</button>' +
                '</div>' +
            '</div>' +
        '</div>'
    );

    posts.click(function(){showForumContent($(this),false);});
    newPostButton.click(function(){showForumContent($(this),true);});

    let mobileBackHandler = function(){
        if(curPost.hasClass("active")){
            curPost.removeClass("active");
            displayedPosts.pop().remove();
            forum.removeClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");
            nav.width(nav.parent().width());
        }
    };

    /**
     *
     * @param clickedObject jQuery Object the button that was clicked
     * @param newPost boolean true if writing a new post
     */
    let showForumContent = function(clickedObject, newPost){
        curPost = clickedObject;

        if(displayedPosts.length > 0)
            displayedPosts.pop().remove();

        if(curPost.hasClass("active")){
            resetForum();
            return;
        }

        let displayedContent;

        if(newPost === true)
            displayedContent = newPostPanel.append(mobileBack);
        else
            displayedContent = postContent.append(mobileBack);


        forum.removeClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");
        posts.addClass("background");
        newPostButton.addClass("background");
        $(".forum-post.active").removeClass("active");
        $("#new-post-button.active").removeClass("active");
        curPost.toggleClass("active");


        forum.addClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");

        displayedPosts.push(displayedContent);
        forum.after(displayedContent);

        nav.affix();
        nav.width(nav.parent().width());

        mobileBack.click(mobileBackHandler);
    };

    let resetForum = function () {
        curPost.removeClass("active");
        posts.removeClass("background");
        newPostButton.removeClass("background");
        forum.removeClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");
        nav.width(nav.parent().width());
    }

});
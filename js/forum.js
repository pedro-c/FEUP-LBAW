/**
 * Created by epassos on 2/25/17.
 */
$(document).ready(function(){
    let forum = $("#forum-posts");
    let posts = $(".forum-post");
    let nav = $(".forum-posts-nav");
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

    posts.click(function(){
        curPost = $(this);
        if(curPost.hasClass("active")){
            curPost.removeClass("active");
            displayedPosts.pop().remove();
            forum.removeClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");
            nav.width(nav.parent().width());
            return;
        }

        $(".forum-post.active").removeClass("active");
        curPost.toggleClass("active");


        forum.addClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");
        postContent.append(mobileBack);
        displayedPosts.push(postContent);
        forum.after(postContent);

        nav.affix();
        nav.width(nav.parent().width());

        mobileBack.click(mobileBackHandler);
    });

    let mobileBackHandler = function(){
        if(curPost.hasClass("active")){
            curPost.removeClass("active");
            displayedPosts.pop().remove();
            forum.removeClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");
            nav.width(nav.parent().width());
            return;
        }
    }
});
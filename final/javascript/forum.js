/**
 * Created by epassos on 2/25/17.
 */
$(document).ready(function () {
    let forum = $("#forum-posts");
    let postListing = $("#post-listing");
    let currentPage = parseInt($("ul.pagination li.active").text());

    loadPagePosts(postListing, currentPage);

    let nav = $(".forum-posts-nav");
    let newPostButton = $("#new-post-button");
    let curPost;
    let curPostID;
    let posts = $(".forum-post");
    let paginationElements = $(".pagination li");

    paginationElements.click(function () {
        performPagination($(this),currentPage);
    });

   let performPagination = function(clickedObject, curPage){
       let selectedPage;
       console.log(clickedObject);
       if (clickedObject.is("#pagination-next"))
           selectedPage = curPage + 1;
       else if (clickedObject.is("#pagination-prev"))
           selectedPage = curPage - 1;
       else selectedPage = parseInt($(this).text());
       if (selectedPage === curPage)
           return;

       console.log(curPage);
       console.log(selectedPage);
       postListing.empty();
       currentPage = selectedPage;
       $(".pagination li.active").removeClass("active");
       $('.pagination li:contains("' + selectedPage + '")').addClass("active");
       console.log('.pagination li:contains("'+selectedPage+'")');
       loadPagePosts(postListing, selectedPage);
   }


    let displayedPosts = [];
    let mobileBack = $(
        '<div id="mobile-back" class="hidden-lg hidden-md hidden-sm navbar navbar-default navbar-fixed-bottom">' +
        '<h4>« Back</h4>' +
        '</div>'
    );

    let newPostPanel = $(
        '<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12">' +
        '<div id="new-post-panel" class="panel panel-primary">' +
        '<div class="panel-heading"><h3 class="panel-title">New Post</h3></div>' +
        '<div class="panel-body">' +
        '<form action="../actions/forum/submit_new_post.php" method="post">' +
        '<div class="form-group">' +
        '<input type="text" class="form-control" name="post_title" id="new-post-title" required="required" placeholder="Post Title">' +
        '<textarea class="form-control" name="post_content" rows="17" id="new-post-text" style="resize: none" required="required" placeholder="Write something"></textarea>' +
        '</div>' +
        '<button id="submit-new-post" class="btn btn-default btn-form" type="submit">Submit</button>' +
        '<button id="cancel-new-post" class="btn btn-default btn-form">Cancel</button>' +
        '</form>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '</div>'
    );

    postListing.on('click', '.forum-post', function () {
        showForumContent($(this), false);
    });

    newPostButton.click(function () {
        showForumContent($(this), true);
    });

    let mobileBackHandler = function () {
        if (curPost.hasClass("active")) {
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
    let showForumContent = function (clickedObject, newPost) {
        curPost = clickedObject;

        if (displayedPosts.length > 0)
            displayedPosts.pop().remove();

        if (curPost.hasClass("active")) {
            resetForum();
            return;
        }


        forum.removeClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");
        posts.addClass("background");
        newPostButton.addClass("background");
        $(".forum-post.active").removeClass("active");
        $("#new-post-button.active").removeClass("active");
        curPost.toggleClass("active");


        forum.addClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");

        let displayedContent;

        if (newPost === true)
            displayedContent = newPostPanel.append(mobileBack);
        else {
            let selectedPost = makePostSection(clickedObject);
            displayedContent = selectedPost.append(mobileBack);
        }

        displayedPosts.push(displayedContent);
        forum.after(displayedContent);

        nav.affix();
        nav.width(nav.parent().width());

        mobileBack.click(mobileBackHandler);
        $("#cancel-new-post").click(mobileBackHandler);

        $("#new-post-title").focus();

        $("#reply-post-button").click(function () {
            $('html, body').animate({
                scrollTop: $("#post-reply").offset().top
            }, 500);

            $("#post-reply textarea").focus();
        });
    };

    /**
     * Called when a user minimizes a post
     */
    let resetForum = function () {
        curPost.removeClass("active");
        curPostID = -1;
        posts.removeClass("background");
        newPostButton.removeClass("background");
        forum.removeClass("col-lg-3 col-md-3 col-sm-3 hidden-xs");
        nav.width(nav.parent().width());
    };


    /**
     * Creates the post element, fetches all the important information
     * Such as the content and the replies
     * @param clickedPost
     * @returns {*|jQuery|HTMLElement}
     */
    let makePostSection = function (clickedPost) {
        let header = getPostHeader(clickedPost);
        let content = getPostContent(clickedPost);
        let replies = getPostReplies(clickedPost);
        let username = $("#nav-user-username").text();

        let postSection = $(
            '<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12">' +
            '<div id="post-content" class="panel panel-primary">' + header +
            '</div>' +
            '<div id="reply-button">' +
            '<a id="reply-post-button" class="btn btn-default btn-reply"><i class="glyphicon glyphicon-plus"></i> Reply to this post</a>' +
            '</div>' +
            '<li id="post-reply" class="list-group-item">' +
            '<h5 class="list-group-item-heading"><img class="submitter-photo" src="../../images/users/avatar7.png"><strong>' + username + '</strong></h5>' +
            '<textarea id="reply-text" class="form-control" rows="3" style="resize: none" required="required" placeholder="Reply to this post"></textarea>' +
            '<button id="submit-reply" class="btn btn-default btn-form btn-comment">Submit</button>' +
            '</li>' +
            '</div>'
        );

        postSection.find("#submit-reply").click(submitReply);

        postSection.find("#post-content").append(content);
        postSection.find("#reply-post-button").after(replies);

        return postSection;
    };

    /**
     * Returns the header for the post element
     * @param clickedPost
     * @returns {string}
     */
    let getPostHeader = function (clickedPost) {
        let title = clickedPost.find(".post-title").text();
        let userPhoto = clickedPost.find(".submitter-photo").attr("src");
        let username = clickedPost.find(".submitter-uname").text();
        let submissionDate = clickedPost.find(".post-submission-date").text();


        return '<div class="panel-heading">' +
            '<h3 class="panel-title">' + title + '</h3>' +
            '<span>' +
            '<img id="selected-post-submitter-info" class="submitter-photo" src=' + userPhoto + '>' +
            '<small>' + username + ' on ' + submissionDate +
            '</small>' +
            '</span>' +
            '</div>';
    };

    /**
     * Returns the content of the selected post
     * @param clickedPost
     * @returns {*|jQuery|HTMLElement}
     */
    let getPostContent = function (clickedPost) {
        curPostID = clickedPost.find(".post-id").text();

        let content = $(
            '<div class="panel-body" id="selected-post-content">' +
            '</div>'
        );

        $.post("../api/forum/get_post_content.php", {
            postID: parseInt(curPostID)
        }, function (data) {
            content.text(data);
        });

        return content;
    };

    /**
     * Returns the replies for the selected post
     * @param clickedPost
     * @returns {*|jQuery|HTMLElement}
     */
    let getPostReplies = function (clickedPost) {
        let content = $(
            '<ul id="replies" class="list-group">' +
            '</ul>'
        );

        $.post("../api/forum/get_post_replies.php", {
            postID: parseInt(curPostID)
        }, function (data) {
            let replies = JSON.parse(data);
            for (let reply of replies) {
                let replyContent = reply.content;
                let id = reply.id;
                let creationDate = reply.creation_date;
                let userPhoto = reply.photo;
                let username = reply.username;

                let replyElement = $(
                    '<li class="list-group-item">' +
                    '<h5 class="list-group-item-heading"><img class="submitter-photo" src=' + userPhoto + '><strong>' + username + ' on ' + creationDate + '</strong></h5>' +
                    '<p class="list-group-item-text">' + replyContent + '</p>' +
                    '</li>'
                );

                content.append(replyElement);
            }
        });
        return content;
    };

    /**
     * Creates a post request to submit a reply to a post
     * and then displays the post in the page
     */
    let submitReply = function () {
        let text = $("#reply-text");
        let content = text.val();
        if (content === null || content === "")
            return;


        $.post("../api/forum/submit_post_reply.php", {
            postID: curPostID,
            content: content,
        }, function (data) {
            let reply = JSON.parse(data);
            let replyContent = reply.content;
            let id = reply.id;
            let creationDate = reply.creation_date;
            let userPhoto = reply.photo;
            let username = reply.username;

            let replyElement = $(
                '<li class="list-group-item">' +
                '<h5 class="list-group-item-heading"><img class="submitter-photo" src=' + userPhoto + '><strong>' + username + ' on ' + creationDate + '</strong></h5>' +
                '<p class="list-group-item-text">' + replyContent + '</p>' +
                '</li>'
            );

            $("#replies:last-child").append(replyElement);
        });

        text.val("");
    }
});

/**
 * Creates a post request to get the page's posts
 * @param postsSection
 * @param currentPage
 */
function loadPagePosts(postsSection, currentPage) {
    $.post("../api/forum/get_page_posts.php", {
        forum_page: currentPage
    }, function (data) {
        let posts = JSON.parse(data);
        for (let post of posts) {
            let photo = post.submitter_photo;
            let postID = post.id;
            let title = post.title;
            let creationDate = post.creation_date;
            let username = post.username;

            let postElement = $(
                '<button class="list-group-item forum-post">' +
                '<span class="post-id" hidden="hidden">' + postID + '</span>' +
                '<h4 class="list-group-item-heading post-title">' + title + '</h4>' +
                '<div class="list-group-item-text post-submitter-info">' +
                '<img class="submitter-photo" src="{$photo}">' +
                '<small>' +
                '<span class="submitter-uname">' + username + '</span> - ' +
                '<span class="post-submission-date">' + creationDate + '</span>' +
                '</small>' +
                '</div>' +
                '</button>'
            );

            postsSection.append(postElement);
        }
    })
}

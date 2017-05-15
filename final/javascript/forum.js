/**
 * Created by epassos on 2/25/17.
 */
$(document).ready(function () {
    let currentPage = 1;

    let forum = $("#forum-posts");
    let postListing = $("#post-listing");

    loadPagination(currentPage);
    loadPagePosts(postListing, currentPage);

    let nav = $(".forum-posts-nav");
    let newPostButton = $("#new-post-button");
    let curPost;
    let curPostID;
    let posts = $(".forum-post");
    let pagination = $(".pagination");

    pagination.on('click', 'li', function () {
        performPagination($(this), currentPage);
        loadPagination(currentPage);
    });

    $("body").on('click', '.reply-like-button', function () {
        let replyElement = $(this).parents(".forum-reply");
        if ($(this).hasClass('liked')) {
            //unlike
            unlikeReply(replyElement);
        }
        else {
            //like
            likeReply(replyElement);
        }
    });


    let performPagination = function (clickedObject, curPage) {
        let numPages = parseInt($("#pagination-n-pages").text());
        let selectedPage;

        if (clickedObject.is("#pagination-next")) {
            console.log(curPage);
            if (curPage == numPages)
                return;
            selectedPage = curPage + 1;
        }
        else if (clickedObject.is("#pagination-prev")) {
            console.log(curPage);
            if (curPage == 1)
                return;
            selectedPage = curPage - 1;
        }

        else selectedPage = parseInt(clickedObject.text());

        if (selectedPage == curPage)
            return;

        postListing.empty();
        currentPage = selectedPage;
        $(".pagination li.active").removeClass("active");
        $('.pagination li:contains("' + selectedPage + '")').addClass("active");
        console.log('.pagination li:contains("' + selectedPage + '")');
        loadPagePosts(postListing, selectedPage);
    };


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

            $("#post-reply").find("textarea").focus();
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
        let postId = parseInt(clickedPost.find(".post-id").text());
        curPostID = postId;
        let header = getPostHeader(clickedPost);
        let content = getPostContent(postId);
        let numLikes = getPostLikes(postId);
        let likedByUser = userLikedPost(postId);
        let replies = getPostReplies(postId);
        let username = $("#nav-username").text();
        let photo = $(".nav-user-picture").attr("src");

        let postSection = $(
            '<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12">' +
            '<div id="post-content" class="panel panel-primary">' + header +
            '<div class="panel-body"></div>' +
            '</div>' +
            '<div id="reply-button">' +
            '<a id="reply-post-button" class="btn btn-default btn-reply"><i class="glyphicon glyphicon-plus"></i> Reply to this post</a>' +
            '</div>' +
            '<li id="post-reply" class="list-group-item">' +
            '<h5 class="list-group-item-heading"><img class="submitter-photo" src="' + photo + '"><strong>' + username + '</strong></h5>' +
            '<textarea id="reply-text" class="form-control" rows="3" style="resize: none" required="required" placeholder="Reply to this post"></textarea>' +
            '<button id="submit-reply" class="btn btn-default btn-form btn-comment">Submit</button>' +
            '</li>' +
            '</div>'
        );

        postSection.find("#submit-reply").click(submitReply);
        postSection.find(".panel-body").append(content);
        postSection.find(".panel-body").append(
            '<div class="like-section"><small>' +
            '<span class="post-likes">' + (numLikes > 0 ? '<i class="fa fa-thumbs-up"></i>' + numLikes + '</span>' : '') +
            '<span class="post-like-button ' + (likedByUser ? 'liked' : '') + '">' +
            '<i class="fa fa-thumbs-up"></i>' +
            '<span class="like-status"> ' + (likedByUser ? 'Liked' : 'Like') + '</span>' +
            '</span>' +
            '</small></div>'
        );
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
            '<h3 class="panel-title selected-post-title"><strong>' + title + '</strong></h3>' +
            '<span>' +
            '<img id="selected-post-submitter-info" class="submitter-photo" src=' + userPhoto + '>' +
            '<small>' + username + ' on ' + submissionDate +
            '</small>' +
            '</span>' +
            '</div>';
    };

    /**
     * Returns the content of the selected post
     * @returns {*|jQuery|HTMLElement}
     * @param postId
     */
    let getPostContent = function (postId) {

        let content = $(
            '<div id="selected-post-content">' +
            '</div>'
        );

        $.post("../api/forum/get_post_content.php", {
            postID: postId
        }, function (data) {
            content.text(data);
        });

        return content;
    };

    /**
     * Returns the replies for the selected post
     * @returns {*|jQuery|HTMLElement}
     * @param postId
     */
    let getPostReplies = function (postId) {
        let content = $(
            '<ul id="replies" class="list-group">' +
            '</ul>'
        );

        $.post("../api/forum/get_post_replies.php", {
            postID: postId
        }, function (data) {
            console.log(data);
            let replies = JSON.parse(data);
            for (let reply of replies) {
                let id = reply.reply_id;
                let replyContent = reply.content;
                let numLikes = reply.n_likes;
                let creationDate = reply.creation_date;
                let userPhoto = reply.photo;
                let username = reply.username;
                let likedByUser = reply.liked;

                let replyElement = makeReplyElement(id, userPhoto, username, creationDate, numLikes, replyContent, likedByUser);
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
            post_id: curPostID,
            content: content,
        }, function (data) {
            console.log(data);
            let reply = JSON.parse(data);
            let replyContent = reply.content;
            let id = reply.id;
            console.log(id);
            let creationDate = reply.creation_date;
            let userPhoto = reply.photo;
            let username = reply.username;

            let replyElement = makeReplyElement(id, userPhoto, username, creationDate, 0, replyContent, false);
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
                '<img class="submitter-photo" src="' + photo + '">' +
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

function loadPagination(currentPage) {
    let nPages = parseInt($("#pagination-n-pages").text());

    $.post("../api/forum/get_num_pages.php",
        function (data) {
            let numPages = data;

            if (nPages === numPages)
                return;

            if (numPages <= 0)
                return;

            let paginationPages = $(".pagination");
            paginationPages.empty();

            paginationPages.append('<i id="pagination-n-pages" hidden="hidden">' + numPages + '</i>');

            paginationPages.append(
                '<li id="pagination-prev"' + (currentPage === 1 ? 'class="disabled"' : '') + '>' +
                '<a href="#" aria-label="Previous">' +
                '<span aria-hidden="true">&laquo;</span>' +
                '</a>' +
                '</li>'
            );

            for (let i = 1; i <= numPages; i++) {
                let element = null;

                if (i === currentPage) {
                    element = $('<li class="active"><a>' + i + '</a></li>');
                }
                else if (i == 1 || i == numPages || (i >= currentPage - 1 && i <= currentPage + 1)) {
                    element = $('<li><a>' + i + '</a></li>');
                }

                if (element === null)
                    continue;

                if (i == 1) {
                    element.attr('id', 'pagination-first'); //= '<li id="pagination-first"><a>' + i + '</a></li>';
                }
                if (i == numPages) {
                    element.attr('id', 'pagination-last'); // element = '<li id="pagination-last"><a>' + i + '</a></li>';
                }

                paginationPages.append(element);

            }

            paginationPages.append(
                '<li id="pagination-next"' + (currentPage === numPages ? 'class="disabled"' : '') + '>' +
                '<a href="#" aria-label="Previous">' +
                '<span aria-hidden="true">&raquo;</span>' +
                '</a>' +
                '</li>'
            );
        });
}

function getPostLikes(postId) {
    let likes = 0;
    $.post(
        "../api/forum/get_post_likes.php", {
            post_id: postId
        }, function (data) {
            console.log(likes);
            likes = data;
        }
    );

    console.log(likes);
    return likes;
}

function userLikedPost(postId) {
    let likedByUser = false;
    $.post(
        "../api/forum/user_liked_post.php", {
            post_id: postId
        }, function (data) {
            likedByUser = JSON.parse(data);
        }
    );

    return likedByUser;
}

function likeReply(replyElement) {
    let replyId = parseInt(replyElement.find(".reply-id").text());
    $.post("../api/forum/like_reply.php", {
        reply_id: replyId
    }, function (data) {
        let replyLikeButton = replyElement.find(".reply-like-button");
        replyLikeButton.addClass("liked");
        replyLikeButton.find(".like-status").text(' Liked');
        replyElement.find(".reply-likes").html("<strong><i class='fa fa-thumbs-up'></i> " + data + "</strong>")
    });
}

function unlikeReply(replyElement) {
    let replyId = parseInt(replyElement.find(".reply-id").text());
    $.post("../api/forum/unlike_reply.php", {
        reply_id: replyId
    }, function (data) {
        let replyLikeButton = replyElement.find(".reply-like-button");
        replyLikeButton.removeClass("liked");
        replyLikeButton.find(".like-status").text(' Like');
        replyElement.find(".reply-likes").html(
            (data > 0 ? '<strong><i class="fa fa-thumbs-up"></i> ' + data + '</strong>' : '')
        );
    });
}

function makeReplyElement(replyId, userPhoto, username, creationDate, numLikes, replyContent, likedByUser) {
    return $(
        '<li class="list-group-item forum-reply">' +
        '<h5 class="list-group-item-heading">' +
        '<span hidden="hidden" class="reply-id">' + replyId + '</span>' +
        '<img class="submitter-photo" src=' + userPhoto + '>' +
        '<strong>' + username + ' on ' + creationDate + '</strong>' +
        '<span class="reply-likes">' + (numLikes > 0 ? '<strong><i class="fa fa-thumbs-up"></i> ' + numLikes + '</strong>' : '') + '</span>' +
        '</h5>' +
        '<p class="list-group-item-text reply-content">' + replyContent + '</p>' +
        '<p><small class="reply-like-button ' + (likedByUser ? 'liked' : '') + '">' +
        '<i class="fa fa-thumbs-up"></i>' +
        '<span class="like-status"> ' + (likedByUser ? 'Liked' : 'Like') + '</span>' +
        '</small></p>' +
        '</li>'
    )
}
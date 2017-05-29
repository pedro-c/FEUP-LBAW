$(document).ready(function () {

    $("li#icon-forum a").css("background-color","#192532");
    $("li#icon-forum a").css("color", "#e9d460");

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

    /*
     ************************************ Click Handlers Start *****************************************************
     */

    /*
     * Click Handler for pagination
     */
    pagination.on('click', 'li', function () {
        performPagination($(this), currentPage);
        loadPagination(currentPage);
    });

    /*
     * Click Handler for the like button on replies
     */
    $("body").on('click', '.reply-like-button', function () {
        let replyElement = $(this).parents(".forum-reply");
        if ($(this).hasClass('liked')) {
            unlikeReply(replyElement);
        }
        else {
            likeReply(replyElement);
        }
    });

    /*
     * Click Handler for the submit reply button
     */
    $('body').on('click', '#submit-reply', function () {
        let text = $("#reply-text");
        let content = text.val();
        if (content === null || content === "")
            return;

        $.post("../api/forum/submit_post_reply.php", {
            post_id: curPostID,
            content: content,
        }, function (data) {
            let reply = JSON.parse(data);
            let replyContent = reply.content;
            let id = reply.id;
            let creationDate = reply.creation_date;
            let userPhoto = reply.photo;
            let username = reply.username;

            let replyElement = makeReplyElement(id, userPhoto, username, creationDate, 0, replyContent, false, true, true);
            $("#replies").append(replyElement);

            $('html, body').animate({
                scrollTop: replyElement.offset().bottom
            }, 500);
        });

        text.val("");
    });

    /*
     * Click Handler for the post like button
     */
    $("body").on('click', '.post-like-button', function () {
        let postElement = $(this).parents("#open-forum-post");
        if ($(this).hasClass('liked')) {
            unlikePost(postElement);
        }
        else {
            likePost(postElement);
        }
    });

    /*
     * Click Handler for the reply edit button
     */
    $("body").on('click', '.edit-reply-option', function (e) {
        e.preventDefault();
        let replyElement = $(this).parents(".forum-reply");

        if (replyElement.find("[class=reply-edit-buttons]").length !== 0)
            return;
        let replyContentElement = replyElement.find('.reply-content');

        if (replyContentElement === null)
            return;

        let replyContent = replyElement.find('.reply-content').text();
        let textbox = $(
            '<textarea class="form-control reply-edit-text" rows="3" style="resize: none"' +
            ' required="required">' + replyContent + '</textarea>' +
            '<span hidden="hidden" class="cur-reply-content">' + replyContent + '</span>' +
            '<div class="reply-edit-buttons">' +
            '<button class="submit-reply-edit btn btn-default btn-form" type="submit">Submit</button>' +
            '<button class="cancel-reply-edit btn btn-default btn-form">Cancel</button>' +
            '</div>'
        );
        replyContentElement.replaceWith(textbox)
    });

    /*
     * Click handler for the reply edit submit button
     */
    $('body').on('click', '.submit-reply-edit', function (e) {
        e.preventDefault();
        let replyElement = $(this).parents(".forum-reply");
        let replyId = parseInt(replyElement.find('span.reply-id').text());
        let replyButtons = replyElement.find(".reply-edit-buttons");

        let text = $(".reply-edit-text");
        let content = text.val();

        if (content === null || content === "")
            return;

        $.post("../api/forum/submit_post_reply_edit.php", {
            reply_id: replyId,
            content: content,
        }, function (data) {
            text.replaceWith(
                $('<p class="list-group-item-text reply-content">' + data + '</p>')
            );
        });

        text.val("");
        replyButtons.remove();
    });

    /*
     * Click handler for the reply edit cancel button
     */
    $('body').on('click', '.cancel-reply-edit', function (e) {
        e.preventDefault();
        let replyElement = $(this).parents(".forum-reply");
        let replyButtons = replyElement.find(".reply-edit-buttons");
        let replyContentElement = replyElement.find(".cur-reply-content");
        let replyContentText = replyContentElement.text();

        let text = $(".reply-edit-text");

        text.replaceWith(
            $('<p class="list-group-item-text reply-content">' + replyContentText + '</p>')
        );

        replyContentElement.remove();
        replyButtons.remove();
    });

    /*
     * Click handler for the reply delete button
     */
    $('body').on('click', '.delete-reply-option', function (e) {
        e.preventDefault();
        let replyElement = $(this).parents(".forum-reply");

        if (replyElement.find("[class=reply-delete-buttons]").length !== 0)
            return;

        let deleteOptionButtons = $(
            '<div class="reply-delete-buttons">' +
            '<p class="delete-reply-prompt">' +
            'Are you sure you want to delete this reply?' +
            '</p>' +
            '<button class="btn btn-default btn-form confirm-delete-reply" type="submit">Delete</button>' +
            '<button class="btn btn-default btn-form cancel-delete-reply">Cancel</button>' +
            '</div>'
        );
        replyElement.append(deleteOptionButtons);
    });


    /*
     * Click handler for the reply delete confirm button
     */
    $('body').on('click', '.confirm-delete-reply', function (e) {
        e.preventDefault();

        let replyElement = $(this).parents(".forum-reply");
        let replyId = parseInt(replyElement.find('span.reply-id').text());

        $.post("../api/forum/delete_post_reply.php", {
            reply_id: replyId
        }, function (data) {
            if (data === 'success')
                replyElement.remove();
        });

    });

    /*
     * Click handler for the reply delete cancel button
     */
    $('body').on('click', '.cancel-delete-reply', function (e) {
        e.preventDefault();
        let replyElement = $(this).parents(".forum-reply");
        let replyButtons = replyElement.find(".reply-delete-buttons");
        replyButtons.remove();
    });

    /*
     * Click handler for the post edit button
     */
    $("body").on('click', '.edit-post-option', function (e) {
        e.preventDefault();
        let postElement = $(this).parents("#open-forum-post");

        if (postElement.find("[class=post-edit-buttons]").length !== 0)
            return;
        let postContentElement = postElement.find('#post-content');
        let postContent = postContentElement.text();
        let textbox = $(
            '<textarea class="post-edit-text form-control" rows="8" style="resize: none"' +
            ' required="required">' + postContent + '</textarea>' +
            '<span hidden="hidden" class="cur-post-content">' + postContent + '</span>' +
            '<div class="post-edit-buttons">' +
            '<button class="submit-post-edit btn btn-default btn-form" type="submit">Submit</button>' +
            '<button class="cancel-post-edit btn btn-default btn-form">Cancel</button>' +
            '</div>'
        );
        postContentElement.replaceWith(textbox)
    });

    /*
     * Click handler for the forum post edit submit button
     */
    $('body').on('click', '.submit-post-edit', function (e) {
        e.preventDefault();
        let postElement = $(this).parents("#open-forum-post");
        let postId = parseInt(postElement.find('#current-post-id').text());
        let postButtons = postElement.find(".post-edit-buttons");
        let postContentElement = postElement.find(".cur-post-content");

        let text = $(".post-edit-text");
        let content = text.val();

        if (content === null || content === "")
            return;

        $.post("../api/forum/submit_post_edit.php", {
            post_id: postId,
            content: content,
        }, function (data) {
            text.replaceWith(
                $('<p class="post-content">' + data + '</p>')
            );
        });

        text.val("");
        postContentElement.remove();
        postButtons.remove();
    });

    /*
     * Click handler for the forum post edit cancel button
     */
    $('body').on('click', '.cancel-post-edit', function (e) {
        e.preventDefault();
        let postElement = $(this).parents("#open-forum-post");
        let postButtons = postElement.find(".post-edit-buttons");
        let postContentElement = postElement.find(".cur-post-content");
        let postContentText = postContentElement.text();

        let text = $(".post-edit-text");

        text.replaceWith(
            $('<p id="post-content">' + postContentText + '</p>')
        );

        postContentElement.remove();
        postButtons.remove();
    });

    /*
     * Click handler for the post delete button
     */
    $('body').on('click', '.delete-post-option', function (e) {
        e.preventDefault();
        let postElement = $(this).parents("#open-forum-post");
        let postId = parseInt(postElement.find('#current-post-id').text());

        if (postElement.find("[class=reply-delete-buttons]").length !== 0)
            return;

        let deleteOptionButtons = $(
            '<form action="../actions/forum/delete_post.php" method="post">' +
            '<div class="post-delete-buttons">' +
            '<p class="delete-post-prompt">' +
            'Are you sure you want to delete this post?' +
            '</p>' +
            '<input hidden="hidden" name="post_id" value="'+ postId + '">' +
            '<button class="btn btn-default btn-form confirm-delete-post" type="submit">Delete</button>' +
            '<button class="btn btn-default btn-form cancel-delete-post" type="button">Cancel</button>' +
            '</div>' +
            '</form>'
        );
        postElement.append(deleteOptionButtons);
    });

    /*
     * Click handler for the post delete cancel button
     */
    $('body').on('click', '.cancel-delete-post', function (e) {
        e.preventDefault();
        let postElement = $(this).parents("#open-forum-post");
        let postButtons = postElement.find(".post-delete-buttons");
        postButtons.remove();
    });
    /*
     ************************************ Click Handlers End *****************************************************
     */

    /**
     * Perform the forum pagination, called when a button on the pagination nav is clicked
     * @param clickedObject
     * @param curPage
     */
    let performPagination = function (clickedObject, curPage) {
        let numPages = parseInt($("#pagination-n-pages").text());
        let selectedPage;

        if (clickedObject.is("#pagination-next")) {
            if (curPage == numPages)
                return;
            selectedPage = curPage + 1;
        }
        else if (clickedObject.is("#pagination-prev")) {
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
        '<input type="text" class="form-control" name="post_title" id="new-post-title" required="required" ' +
        'placeholder="Post Title">' +
        '<textarea class="form-control" name="post_content" rows="17" id="new-post-text" style="resize: none"' +
        ' required="required" placeholder="Write something"></textarea>' +
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

        if (displayedPosts.length > 0) {
            let post = displayedPosts.pop();
            post.remove();

        }

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


        if (newPost === true) {
            newPostPanel.append(mobileBack);
            forum.after(newPostPanel);
            displayedPosts.push(newPostPanel)
        }
        else
            loadPost(forum, clickedObject, mobileBack, displayedPosts);


        nav.affix();
        nav.width(nav.parent().width());

        mobileBack.click(mobileBackHandler);
        $("#cancel-new-post").click(mobileBackHandler);

        $("#new-post-title").focus();

        $('body').on('click', "#reply-post-button", function () {
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
        nav.removeClass('affix affix-top affix-bottom').removeData('bs.affix');
        nav.on('affix-top.bs.affix', function (e) {
            e.preventDefault()
        });
        nav.css('width', 'inherit');
    };


    /**
     * Creates the post element, fetches all the important information
     * Such as the content and the replies
     * @param clickedPost
     * @returns {*|jQuery|HTMLElement}
     */
    let loadPost = function (forum, clickedPost, mobileBack, displayedPostsStack) {
        let postId = parseInt(clickedPost.find(".post-id").text());
        curPostID = postId;


        /*
         * Load the post information
         * title, username, userphoto and submission date
         * content
         * number of likes
         */
        $.post("../api/forum/get_forum_post.php", {
            post_id: postId
        }, function (data) {

            let postInfo = JSON.parse(data);
            let id = postInfo.id;
            let title = postInfo.title;
            let creationDate = postInfo.creation_date;
            let content = postInfo.content;
            let dateModified = postInfo.date_modified;
            let username = postInfo.username;
            let photo = postInfo.photo;
            let numLikes = postInfo.num_likes;
            let likedByUser = postInfo.liked_by_user;
            let userCanDelete = postInfo.user_can_delete;
            let userCanEdit = postInfo.user_can_edit;

            let postElement = makePostElement(id, title, creationDate, content, dateModified, username, photo, numLikes,
                likedByUser, userCanDelete, userCanEdit);
            postElement.append(mobileBack);

            displayedPostsStack.push(postElement);
            forum.after(postElement);

        });
    };
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
    });
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
                    element.attr('id', 'pagination-first');
                }
                if (i == numPages) {
                    element.attr('id', 'pagination-last');
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


function likePost(postElement) {
    let postId = parseInt(postElement.find('#current-post-id').text());
    $.post("../api/forum/like_post.php", {
        post_id: postId
    }, function (data) {
        let replyLikeButton = postElement.find(".post-like-button");
        replyLikeButton.addClass("liked");
        replyLikeButton.find(".like-status").text(' Liked');
        postElement.find(".post-likes").html("<strong><i class='fa fa-thumbs-up'></i> " + data + "</strong>")
    });
}

function unlikePost(postElement) {
    let postId = parseInt(postElement.find('#current-post-id').text());
    $.post("../api/forum/unlike_post.php", {
        post_id: postId
    }, function (data) {
        let replyLikeButton = postElement.find(".post-like-button");
        replyLikeButton.removeClass("liked");
        replyLikeButton.find(".like-status").text(' Like');
        postElement.find(".post-likes").html(
            data > 0 ? '<strong><i class="fa fa-thumbs-up"></i> ' + data + '</strong>' : ''
        );
    });
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

function makeReplyElement(replyId, userPhoto, username, creationDate, numLikes, replyContent, likedByUser, userCanEdit, userCanDelete) {
    let replyElement = $(
        '<li class="list-group-item forum-reply">' +
        '<h5 class="list-group-item-heading">' +
        '<span hidden="hidden" class="reply-id">' + replyId + '</span>' +
        '<img class="submitter-photo" src=' + userPhoto + '>' +
        '<strong>' + username + ' on ' + creationDate + '</strong>' +
        (userCanEdit ? '<span class="forum-options reply-options"></span>' : '') +
        '<span class="reply-likes">' + (numLikes > 0 ? '<strong><i class="fa fa-thumbs-up"></i> ' + numLikes + '</strong>' : '') +
        '</span>' +
        '</h5>' +
        '<p class="list-group-item-text reply-content">' + replyContent + '</p>' +
        '<p><small class="reply-like-button ' + (likedByUser ? 'liked' : '') + '">' +
        '<i class="fa fa-thumbs-up"></i>' +
        '<span class="like-status"> ' + (likedByUser ? 'Liked' : 'Like') + '</span>' +
        '</small></p>' +
        '</li>'
    );

    if (userCanDelete) {
        let dropdown = makeReplyOptions(userCanEdit);
        replyElement.find(".reply-options").append(dropdown);
    }

    return replyElement;
}

function makeReplyOptions(userCanEdit) {
    return $(
        '<div class="btn-group dropdown">' +
        '<button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true"' +
        ' aria-expanded="false">' +
        '<span class="sr-only">Toggle Dropdown</span>' +
        '<i class="fa fa-caret-down"></i>' +
        '</button>' +
        '<div class="dropdown-menu">' +
        (userCanEdit ? '<a class="dropdown-item edit-reply-option" href="#">Edit Reply</a>' : '') +
        '<a class="dropdown-item delete-reply-option" href="#">Delete Reply</a>' +
        '</div>' +
        '</div>');
}

function makePostElement(id, title, creationDate, content, dateModified, username, photo, numLikes, likedByUser, userCanDelete, userCanEdit) {
    let replies = getPostReplies(id);
    let post = $(
        '<div class="col-lg-9 col-md-9 col-sm-9 col-xs-12">' +
        '<div id="open-forum-post" class="panel panel-primary">' +
        '<div class="panel-heading">' +
        '<span hidden="hidden" id="current-post-id">' + id + '</span>' +
        '<h3 class="panel-title selected-post-title"><strong>' + title + '</strong></h3>' +
        '<span>' +
        '<img id="selected-post-submitter-info" class="submitter-photo" src=' + photo + '>' +
        '<small>' + username + ' on ' + creationDate + '</small>' +
        '<span class="forum-options post-options"></span>' +
        '</span>' +
        '</div>' +
        '<div class="panel-body">' +
        '<div class="post-likes">' + (numLikes > 0 ? '<i class="fa fa-thumbs-up"></i>' + numLikes : '') + '</div>' +
        '<p id="post-content">' +
        content +
        '</p>' +
        '<div class="like-section">' +
        '<small>' +
        '<span class="post-like-button ' + (likedByUser ? 'liked' : '') + '"><i class="fa fa-thumbs-up"></i>' +
        '<span class="like-status"> ' + (likedByUser ? 'Liked' : 'Like') + '</span></span>' +
        '</small>' +
        '</div>' +
        '</div>' +
        '</div>' +
        '<div id="reply-button">' +
        '<a id="reply-post-button" class="btn btn-default btn-reply"><i class="glyphicon glyphicon-plus"></i>' +
        ' Reply to this post</a>' +
        '</div>' +
        '</div>' +
        '</div>'
    );

    post.append(replies);

    replies.after(
        '<li id="post-reply" class="list-group-item">' +
        '<h5 class="list-group-item-heading"><img class="submitter-photo" src="' + photo + '">' +
        '<strong>' + username + '</strong></h5>' +
        '<textarea id="reply-text" class="form-control" rows="3" style="resize: none" required="required"' +
        ' placeholder="Reply to this post"></textarea>' +
        '<button id="submit-reply" class="btn btn-default btn-form btn-comment">Submit</button>' +
        '</li>'
    );

    if (userCanDelete) {
        let options = makePostOptions(userCanEdit);
        post.find('.post-options').append(options);
    }

    return post;

}

function makePostOptions(userCanEdit) {
    return $(
        '<div class="btn-group dropdown">' +
        '<button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true"' +
        ' aria-expanded="false">' +
        '<span class="sr-only">Toggle Dropdown</span>' +
        '<i class="fa fa-caret-down"></i>' +
        '</button>' +
        '<div class="dropdown-menu">' +
        (userCanEdit ? '<a class="dropdown-item edit-post-option" href="#">Edit Post</a>' : '') +
        '<a class="dropdown-item delete-post-option" href="#">Delete Post</a>' +
        '</div>' +
        '</div>');
}

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
        let replies = JSON.parse(data);
        for (let reply of replies) {
            let id = reply.reply_id;
            let replyContent = reply.content;
            let numLikes = reply.n_likes;
            let creationDate = reply.creation_date;
            let userPhoto = reply.photo;
            let username = reply.username;
            let likedByUser = reply.liked;
            let userCanEdit = reply.user_can_edit;
            let userCanDelete = reply.user_can_delete;

            let replyElement = makeReplyElement(id, userPhoto, username, creationDate, numLikes, replyContent,
                likedByUser, userCanEdit, userCanDelete);
            content.append(replyElement);
        }
    });
    return content;
};

$(document).ready(function() {

    $("li#icon-team a").css("background-color","#192532");
    $("li#icon-team a").css("color", "#e9d460");

  $('.media-body i').click(function(){
    $(this).css("display", "none");
  });

  $('.profile_details div #zoom_out').click(function(){
    $(this).parents(".panel-body").find("i").css("display", "inline-block");
  })

  //Updates Remove_member_modal parameters when remove button is clicked
  $('.profile_details #profile_actions #remove').click(function() {
    var member_id = $(this).parents(".profile_details").find("input.member_id").attr("value");
    $("#remove_member_dialog [name='user_id']").attr("value", member_id);
  })

  //Updates promote_member_modal parameters when remove button is clicked
  $('.profile_details #profile_actions [data-target="#promote_member_dialog"]').click(function(){
    var member_id = $(this).parents(".profile_details").find("input.member_id").attr("value");
    $("#promote_member_dialog [name='user_id']").attr("value", member_id);
  })

  //Updates demote_member_modal parameters when remove button is clicked
  $('.profile_details #profile_actions [data-target="#demote_member_dialog"]').click(function(){
    var member_id = $(this).parents(".profile_details").find("input.member_id").attr("value");
    $("#demote_member_dialog [name='user_id']").attr("value", member_id);
  })

  $('#add_member_dialog #accept_button').click(function(){
    var email = $('#add_member_dialog input[name="userEmail"]').val()
    var project = $('#add_member_dialog input[name="idProject"]').attr('value');
    var dataString = "userEmail=" + email + "&idProject=" + project;
    console.log(dataString);

    $.ajax({url: '../actions/team/invite_member.php', type: 'POST', data: dataString, dataType: "json",
    success: function(result) {
      if(result['code'] == null){
        alert("User already invited");
      } else {
        alert("Code to accept: " + result['code']);
      }
    },
    error: function (err){
      console.log(err);
      alert("Error occurred: User already invited");
    }});
  })

});

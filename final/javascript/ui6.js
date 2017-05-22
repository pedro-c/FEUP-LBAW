$(document).ready(function() {
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

  $('#add_member_dialog button[type="submit"]').click(function(){
    var email = $('#add_member_dialog input[name="userEmail"]').val()
    var project = $('#add_member_dialog input[name="idProject"]').attr('value');
    var dataString = "userEmail=" + email + "&idProject=" + project;

    $.ajax({url: '../actions/team/invite_member.php', type: 'POST', data: dataString, dataType: "json",
    success: function(result) {
      console.log(result);
      alert("Code to accept: " + result['code']);
    },
    error: function (err){
      console.log(err);
      alert("Error occurred: User already invited");
    }});
  })

});

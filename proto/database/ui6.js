$(document).ready(function() {

  //Hide the expand icon
  $('.media-body i').click(function(){
    $(this).css("display", "none");
  });

  //Display the expand icon
  $('.profile_details div #zoom_out').click(function(){
    $(this).parents(".panel-body").find("i").css("display", "inline-block");
  })

  //Sets the hidden value "member_id" on the Remove Form
  $('.profile_details #profile_actions #remove').click(function() {
    var member_id = $(this).parents(".profile_details").find("input.member_id").attr("value");
    $("#remove_member_dialog [name='user_id']").attr("value", member_id);
  })

  $('#add_member_dialog #accept_button').click(function() {
    var invite_email = $('#add_member_dialog #email_form').val();
    var project_id = $('#add_member_dialog #project_id_form').attr('value');
    var dataString = "idProject=" + project_id + "&userEmail=" + invite_email;
    $.ajax(
      {
        url: "../actions/team/invite_member.php",
        type: 'POST',
        dataType: 'json',
        data: dataString,
        success: function(result){
          if(!result['insert_result']) {
            alert("Could not invite user");
          }
          if(!result['send_result']) {
            alert("Could not send email");
          }
      }});
  });
});

$(document).ready(function() {
  $('.media-body i').click(function(){
    $(this).css("display", "none");
  });

  $('.profile_details div #zoom_out').click(function(){
    $(this).parents(".panel-body").find("i").css("display", "inline-block");
  })

  $('.profile_details #profile_actions #remove').click(function() {
    var member_id = $(this).parents(".profile_details").find("input.member_id").attr("value");
    $("#remove_member_dialog [name='user_id']").attr("value", member_id);
  })
  
});

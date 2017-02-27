$(document).ready(function() {
  $('.media-body i').click(function(){
    $(this).css("display", "none");
  })

  $('.profile_details div i').click(function(){
    $(this).parents(".panel-body").find("i").css("display", "inline-block");
  })
})

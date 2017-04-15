<div class="panel panel-default" id="profile_card">
  <div class="panel-body">
     <div class="media">
          <div class="media-left media-middle" id="profile_pic">
              <img style="width: 100px;" src="../../images/assets/{$profile_image_path}" class="media-object" alt="Profile Photo">
          </div>
          <div class="media-body">
              <h4 class="media-heading">{$profile_name|capitalize}</h4>
              <h5 id="team_role">{$team_role|capitalize}</h5>
              <i class="fa fa-search-plus fa-2x" data-toggle="collapse" data-target="#profile_details{$element_number}"></i>
          </div>
     </div>
     <div id="profile_details{$element_number}" class="collapse">
       <div class="profile_details">
         <div class="row">
           <div class="col-xs-1">
           </div>
           <div class="col-xs-5" align="center">
            <p>From:</p>
           </div>
           <div class="col-xs-5">
             <p>{$city}, {$country}</p>
           </div>
           <div class="col-xs-1">
           </div>
         </div>
         <div class="row">
           <div class="col-xs-1"></div>
           <div class="col-xs-5" align="center">
            <p>Email:</p>
           </div>
           <div class="col-xs-5">
             <p>{$profile_email}</p>
           </div>
           <div class="col-xs-1"></div>
         </div>
         <div class="row">
           <div class="col-xs-1"></div>
           <div class="col-xs-5" align="center">
            <p>Phone:</p>
           </div>
           <div class="col-xs-5">
             <p>{$profile_number}</p> <!-- TODO insert restrictions here-->
           </div>
           <div class="col-xs-1"></div>
         </div>
         <div class="row">
           <div class="col-xs-1"></div>
           <div class="col-xs-5" align="center">
            <p>Profile:</p>
           </div>
           <div class="col-xs-5">
             <a>direkt.com/{$profile_id}</a>
           </div>
           <div class="col-xs-1"></div>
         </div>
         <div class="row" id="profile_actions">
           <div class="col-xs-3"></div>
           <div class="col-xs-3" align="center">
            <i class="fa fa-star fa-3x" id="promote{$element_number}" ></i>
           </div>
           <div class="col-xs-3" align="center">
             <i class="fa fa-times fa-3x" id="remove{$element_number}" data-toggle="modal" data-target="#remove_member_dialog"></i>
           </div>
           <div class="col-xs-3"></div>
         </div>
         <div class="col-xs-12" id="zoom_out_action">
           <i class="fa fa-search-minus fa-2x" data-toggle="collapse" data-target="#profile_details{$element_number}" id="zoom_out"></i>
         </div>
       </div>
     </div>
  </div>
</div>

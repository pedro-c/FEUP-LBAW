<div class="panel panel-default" id="profile_card">
  <div class="panel-body">
     <div class="media">
          <div class="media-left media-middle" id="profile_pic">
              <img style="width: 100px;" src="../../images/{$profile_image_path}" class="media-object" alt="Profile Photo">
          </div>
          <div class="media-body">
              <h4 class="media-heading">{$profile_name|capitalize}</h4>
              <h5 id="team_role">{$team_role|capitalize}</h5>
              <i class="fa fa-search-plus fa-2x" data-toggle="collapse" data-target="#profile_details{$element_number}"></i>
          </div>
     </div>
     <div id="profile_details{$element_number}" class="collapse">
       <div class="profile_details">
         <hr />
         <input type="hidden" class="member_id" value={$profile_id} /> <!-- TODO This will be used to pass values to the modal -->
         <div class="row">
           <div class="col-xs-1">
           </div>
           <div class="col-xs-3" align="center">
            <p>From:</p>
           </div>
           <div class="col-xs-7">
             <p class="attribute_field">{$city}, {$country}</p>
           </div>
           <div class="col-xs-1">
           </div>
         </div>
         <div class="row">
           <div class="col-xs-1"></div>
           <div class="col-xs-3" align="center">
            <p>Email:</p>
           </div>
           <div class="col-xs-7">
             <p class="attribute_field">{$profile_email}</p>
           </div>
           <div class="col-xs-1"></div>
         </div>
         <div class="row">
           <div class="col-xs-1"></div>
           <div class="col-xs-3" align="center">
            <p>Phone:</p>
           </div>
           <div class="col-xs-7">
             <p class="attribute_field">{$profile_number}</p> <!-- TODO insert restrictions here-->
           </div>
           <div class="col-xs-1"></div>
         </div>
         <div class="row">
           <div class="col-xs-1"></div>
           <div class="col-xs-3" align="center">
            <p>Profile:</p>
           </div>
           <div class="col-xs-7">
             <a class="attribute_field">direkt.com/{$profile_id}</a>
           </div>
           <div class="col-xs-1"></div>
         </div>
         <hr />
         {if $coordinator_permissions and !$is_self}
         <div class="row" id="profile_actions">
           <div class="col-xs-3"></div>
           <div class="col-xs-3" align="center">
             {if $team_role eq "Team Member"}
            <i class="fa fa-star fa-3x" id="promote{$element_number}" data-toggle="modal" data-target="#promote_member_dialog"></i>
            {else if $team_role eq "Team Coordinator"}
            <span class="fa-stack fa-lg" id="promote{$element_number}" data-toggle="modal" data-target="#demote_member_dialog">
             <i class="fa fa-star fa-stack-1x"></i>
             <i class="fa fa-ban fa-stack-2x"></i>
           </span>
           {else}
           <i class="fa fa-question fa-3x"></i>
           {/if}
           </div>
           <div class="col-xs-3" align="center">
             <i class="fa fa-times fa-3x" id="remove" data-toggle="modal" data-target="#remove_member_dialog"></i>
           </div>
           <div class="col-xs-3"></div>
         </div>
         {/if}
         <div class="col-xs-12" id="zoom_out_action">
           <i class="fa fa-search-minus fa-2x" data-toggle="collapse" data-target="#profile_details{$element_number}" id="zoom_out"></i>
         </div>
       </div>
     </div>
  </div>
</div>

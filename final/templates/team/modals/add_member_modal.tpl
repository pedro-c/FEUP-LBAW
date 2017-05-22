<div id="add_member_dialog" class="modal fade" role="dialog">
  <div class="modal-dialog">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Add a new member</h4>
      </div>
        <div class="modal-body">
          <p>By clicking "Send", we will be delivering a message with a password to the email below. After registration, the new member
            will have a menu where he can insert that password. When he submits it, you will have a new member on your team!</p>
          <div class="form-group">
            <!-- TODO temporary form -->
            <form action="../actions/team/invite_member.php" method="post">
              <label for="email_form">Email:</label>
              <input type="email" name="userEmail" class="form-control" id="email_form" />
              <input type="hidden" name="idProject" class="form-control" id="project_id_form" value={$project_id} />
            </form>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-default" data-dismiss="modal" id="accept_button">Send</button>
          <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel_button">Close</button>
        </div>
    </div>

  </div>
</div>

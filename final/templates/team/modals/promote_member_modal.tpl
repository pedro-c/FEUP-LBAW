<div id="promote_member_dialog" class="modal fade" role="dialog">
  <div class="modal-dialog modal-sm">

    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Promote member in project</h4>
      </div>
      <div class="modal-body">
        <p>Are you sure you want to promote this member to project coordinator?</p>
      </div>
      <div class="modal-footer">
        <form action="../actions/team/promote-member.php" method="post">
          <input type="hidden" name="project_id" value={$project_id} />
          <input type="hidden" name="user_id" value="0" />
          <button type="submit" class="btn btn-default" id="accept_button">Yes</button>
          <button type="button" class="btn btn-default" data-dismiss="modal" id="cancel_button">No</button>
        </form>
      </div>
    </div>

  </div>
</div>

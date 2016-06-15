class ModeratorsController < ApplicationController
  before_filter :requires_moderator!

  def index
    @mod_pending_trades = Trade.joins(:participants).merge(Participant.needing_moderator_approval)
    @not_accepted_trades = Trade.joins(:participants).merge(Participant.old_and_not_yet_accepted)
  end
end

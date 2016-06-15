class ModeratorsController < ApplicationController
  before_filter :requires_moderator!

  def index
    @mod_pending_trades = Trade.joins(:participants).merge(Participant.needing_moderator_approval).page(params[:mod_pending_page])
    @not_accepted_trades = Trade.joins(:participants).merge(Participant.old_and_not_yet_accepted).page(params[:not_accepted_page])
  end
end

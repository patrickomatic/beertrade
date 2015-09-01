class TradeInviteJob < ActiveJob::Base
  queue_as :default

  def perform(participant_id)
    Participant.find(participant_id).send_invite
  end
end

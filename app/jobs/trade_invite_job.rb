class TradeInviteJob < ActiveJob::Base
  queue_as :default

  def perform(participant_id)
    Notification.send_invites([Participant.find(participant_id)])
  end
end

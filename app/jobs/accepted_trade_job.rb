class AcceptedTradeJob < ActiveJob::Base
  queue_as :default

  def perform(participant_id)
    Notification.accepted_trade(Participant.find(participant_id))
  end
end

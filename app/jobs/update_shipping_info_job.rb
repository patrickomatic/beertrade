class UpdateShippingInfoJob < ActiveJob::Base
  queue_as :default

  def perform(participant_id)
    Notification.updated_shipping(Participant.find(participant_id))
  end
end

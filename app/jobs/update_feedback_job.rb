class UpdateFeedbackJob < ActiveJob::Base
  queue_as :default

  def perform(participant_id)
    Notification.left_feedback(Participant.find(participant_id))
  end
end

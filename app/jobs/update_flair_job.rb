class UpdateFlairJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    #User.find(user_id).update_flair
  end
end

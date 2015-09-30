class CheckIfModeratorJob < ActiveJob::Base
  queue_as :default

  def perform(user_id)
    User.find(user_id).check_if_moderator
  end
end

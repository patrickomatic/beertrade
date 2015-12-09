class UsernameChangeJob < ActiveJob::Base
  queue_as :default

  def perform(old_user_id, new_user_id)
    ModeratorTools.merge_trades_from_user(User.find(old_user_id), User.find(new_user_id))
  end
end

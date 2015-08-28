class Trade < ActiveRecord::Base
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants


  def create_participants(organizer_user, participant_reddit_username)
    participants.create!(user: current_user, accepted_at: Time.now)

    to_invite = @trade.participants.create!(user: User.find_or_create_by(username: participant_reddit_username))
    TradeInviteJob.perform_later to_invite.id

    true
  rescue ActiveRecord::RecordInvalid
    false
  end


  def to_s
    users.map(&:username).join(' and ').tap {|s| s << ": #{agreement}" if agreement?}
  end
end

class Trade < ActiveRecord::Base
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  scope :completed,       ->{ where("completed_at IS NOT NULL").order(completed_at: :desc) }
  scope :pending,         ->{ where(completed_at: nil).order(created_at: :desc) }
  scope :with_user,       ->(user) { joins(:participants).where(participants: {user_id: user.id}) }


  def completed?
    completed_at?
  end

  def all_feedback_given?
    participants.pending.empty?
  end

  def accepted?
    !participants.empty? && !participants.not_yet_accepted.exists?
  end


  def participant(user)
    participants.for_user(user).first
  end


  def waiting_for_approval?(user)
    participant = participant(user)
    return false unless participant
    !participant.accepted?
  end


  def waiting_to_give_feedback?(user)
    accepted? and p = self.participant(user) and p.waiting_to_give_feedback?
  end


  def can_delete?(user)
    waiting_for_approval?(user)
  end


  def create_participants(organizer_user, participant_reddit_username)
    if organizer_user.username.downcase == participant_reddit_username
      self.errors.add(:base, "You cannot request a trade with yourself")
      raise ActiveRecord::RecordInvalid.new(self)
    end

    participants.build(user: organizer_user, accepted_at: Time.now)
    to_invite = participants.build(user: User.find_or_create_by(username: participant_reddit_username))
    save!

    TradeInviteJob.perform_later to_invite.id

    true
  rescue ActiveRecord::RecordInvalid 
    false
  end


  def to_s
    users.map(&:username).join(' and ').tap {|s| s << ": #{agreement}" if agreement?}
  end
end

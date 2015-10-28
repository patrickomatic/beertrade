class Trade < ActiveRecord::Base
  paginates_per 15

  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :notifications

  scope :completed,         ->{ where("completed_at IS NOT NULL").includes(:participants).includes(:users).order(completed_at: :desc) }
  scope :not_completed_yet, ->{ where(completed_at: nil).includes(:participants).includes(:users).order(created_at: :desc) }


  def can_see?(user)
    accepted? || !participant(user).nil? || (user && user.moderator?)
  end

  def completed?
    completed_at?
  end

  def all_feedback_given?
    !participants.empty? && participants.pending.empty?
  end

  def has_shipping_info?
    !participants.empty? && participants.with_shipping_info.exists?
  end

  def accepted?
    !participants.empty? && !participants.not_yet_accepted.exists?
  end

  def waiting_to_give_feedback?(user)
    accepted? and p = self.participant(user) and p.waiting_to_give_feedback?
  end

  def can_delete?(user)
    waiting_for_approval?(user)
  end

  def waiting_for_approval?(user)
    participant = participant(user)
    return false unless participant
    !participant.accepted?
  end


  def participant(user)
    return nil if user.nil?
    participants.find_by(user_id: user.id)
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
    if !agreement.blank?
      agreement 
    else
      "trade on #{created_at.strftime("%m/%d/%Y")}"
    end
  end
end

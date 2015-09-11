class Trade < ActiveRecord::Base
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants

  scope :last_completed, ->{ all } # XXX 
  scope :completed, -> { joins(:participants).where(participants: {feedback: "foo"}).empty? } # XXX 
  scope :with_user, -> { } # XXX


  def completed?
    participants.pending.empty?
  end


  def accepted?
    !participants.empty? && !participants.not_yet_accepted.exists?
  end


  def participant(user)
    participants.for_user(user).first
  end


  def waiting_for_approval?(user)
    !participant(user).accepted_at?
  end


  def waiting_to_give_feedback?(user)
    accepted? and p = self.participant(user) and p.waiting_to_give_feedback?
  end


  def can_delete?(user)
    waiting_for_approval?(user)
  end


  def create_participants(organizer_user, participant_reddit_username)
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

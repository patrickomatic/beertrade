class Participant < ActiveRecord::Base
  paginates_per 20

  enum feedback_type: [:negative, :neutral, :positive]

  belongs_to :trade
  belongs_to :user

  validates :trade, presence: true
  validates :user, presence: true
  validates :shipping_info, tracking_number: true
  validate  :validates_full_feedback

  scope :pending,                    ->{ where(feedback: nil) }
  scope :completed,                  ->{ where("feedback IS NOT NULL") }
  scope :not_yet_accepted,           ->{ where(accepted_at: nil) }
  scope :with_shipping_info,         ->{ where("shipping_info IS NOT NULL") }
  scope :needing_moderator_approval, ->{ where("feedback_type = 0 AND feedback_approved_at IS NULL") }
  scope :with_positive_feedback,     ->{ where(feedback_type: 2) }
  scope :with_neutral_feedback,      ->{ where(feedback_type: 1) }
  scope :with_negative_feedback,     ->{ where(feedback_type: 0) }

  after_update :update_feedback
  after_update :update_shipping_info


  def accepted?
    accepted_at?
  end

  def can_see?(user)
    accepted? && (self.user.id == user.id || !trade.participant(user).nil? || user.moderator?)
  end

  def can_update_shipping_info?(user)
    accepted? && self.user == user
  end

  def can_update_feedback?(user)
    accepted? && !feedback? && (other_participant.user == user || user.moderator?)
  end

  def waiting_to_give_feedback?
    !other_participant.feedback?
  end


  def other_participants
    trade.participants.reject {|p| p == self}
  end

  def other_participant
    other_participants.first
  end


  def finalize_participant!
    user.update_reputation(feedback_type)
    update_attributes(feedback_approved_at: @moderator_approved_at || Time.now)

    UpdateFeedbackJob.perform_later(self.id)
    UpdateFlairJob.perform_later(user.id)

    if trade.all_feedback_given?
      trade.update_attributes(completed_at: Time.now)
    end
  end


  def moderator_approved_at=(time)
    @moderator_approved_at = time
  end

 
  private

    def update_shipping_info
      return unless shipping_info_changed?
      UpdateShippingInfoJob.perform_later(self.id)
    end

    def update_feedback
      return if !feedback_changed? || feedback_approved_at?
      
      if !@moderator_approved_at && negative?
        BadTradeReportedJob.perform_later(self.id)
      else
        finalize_participant!
      end
    end

    def validates_full_feedback
      errors.add(:base, "Must provide both feedback and feedback type") unless full_feedback?
    end

    def full_feedback?
      return (!feedback.nil? && !feedback_type.nil?) if !feedback.nil? || !feedback_type.nil?
      true
    end
end

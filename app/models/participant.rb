class Participant < ActiveRecord::Base
  paginates_per 20

  enum feedback_type: [:negative, :neutral, :positive]

  belongs_to :trade
  belongs_to :user

  validates :trade, presence: true
  validates :user, presence: true
  validates :shipping_info, tracking_number: true
  validate  :validates_full_feedback

  scope :for_user,            ->(user){ where(user_id: user.id) }
  scope :pending,             ->{ where(feedback: nil) }
  scope :completed,           ->{ where("feedback IS NOT NULL") }
  scope :not_yet_accepted,    ->{ where(accepted_at: nil) }
  scope :with_shipping_info,  ->{ where("shipping_info IS NOT NULL") }

  after_update :update_feedback
  after_update :update_shipping_info


  def accepted?
    accepted_at?
  end


  def other_participants
    trade.participants.reject {|p| p == self}
  end


  def other_participant
    other_participants.first
  end


  def can_update_shipping_info?(user)
    self.user == user
  end

  def can_update_feedback?(user)
    other_participant.user == user
  end


  def waiting_to_give_feedback?
    !other_participant.feedback?
  end


  private

    def update_shipping_info
      return unless shipping_info_changed?
      UpdateShippingInfoJob.perform_later(self.id)
    end

    def update_feedback
      return unless feedback_changed?
      user.update_reputation(feedback_type)      

      UpdateFeedbackJob.perform_later(self.id)
      UpdateFlairJob.perform_later(user.id)

      if trade.all_feedback_given?
        trade.update_attributes(completed_at: Time.now)
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

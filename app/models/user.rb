class User < ActiveRecord::Base
  has_many :participants
  has_many :trades, through: :participants

  validates :username, presence: true
  validates :positive_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :neutral_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :negative_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}

  scope :by_feedback, -> { order(XXX) }

  
  def self.find_by_username(username)
    User.where(["LOWER(username) = ?", username.downcase.strip]).first
  end


  def update_reputation(feedback_type)
    case feedback_type
    when "positive"
      increment!(:positive_feedback)
    when "neutral"
      increment!(:neutral_feedback)
    when "negative"
      increment!(:negative_feedback)
    end
  end


  def to_param
    username
  end

  def to_s
    "/u/#{username}"
  end


  def reputation
    ((positive_feedback / (positive_feedback + negative_feedback).to_f) * 100).round
  rescue ZeroDivisionError, FloatDomainError
    0
  end

  def total_completed_trades
    participants.completed.count
  end
end

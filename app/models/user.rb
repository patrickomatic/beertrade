class User < ActiveRecord::Base
  has_many :participants
  has_many :trades, through: :participants
  has_many :notifications

  validates :username,          presence: true
  validates :positive_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :neutral_feedback,  presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :negative_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}

  scope :by_feedback, -> { order(positive_feedback: :desc) }

  
  def self.find_by_username(username)
    User.where(["LOWER(username) = ?", username.downcase.strip]).first
  end


  def unseen_notifications_count
    notifications.unseen.count
  end


  def update_reputation(feedback_type)
    case feedback_type.to_sym
    when :positive
      increment!(:positive_feedback)
    when :neutral
      increment!(:neutral_feedback)
    when :negative
      increment!(:negative_feedback)
    else
      raise "Invalid feedback_type: #{feedback_type}"
    end
  end


  def flair_css_class
    return nil unless positive_feedback > 0
    "repLevel" << case positive_feedback
                  when 1..4
                    "1"
                  when 5..9
                    "2"
                  when 10..39
                    "3"
                  when 40..99
                    "4"
                  else
                    "5"
                  end
  end


  def update_flair
    Reddit.set_flair(username, "#{reputation}% positive", flair_css_class) unless reputation > 0
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

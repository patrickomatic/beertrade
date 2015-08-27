class User < ActiveRecord::Base
  has_many :trades, through: :participants

  validates :username, presence: true
  validates :positive_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :neutral_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :negative_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}

  scope :by_feedback, -> { order(XXX) }

  
  def self.find_by_username(username)
    User.where(["LOWER(username) = ?", username.downcase.strip]).first
  end

  def to_param
    username
  end

  def reputation
    (positive_feedback / (positive_feedback - negative_feedback)) * 100
  end
end

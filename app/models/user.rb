class User < ActiveRecord::Base
  validates :username, presence: true
  validates :positive_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :neutral_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :negative_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}

  scope :by_feedback, -> { order(XXX) }

  def to_param
    username
  end
end

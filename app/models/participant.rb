class Participant < ActiveRecord::Base
  belongs_to :trade
  belongs_to :user

  validates :trade, presence: true
  validates :user, presence: true


  def feedback_description
    if feedback_positive
      "positive"
    elsif feedback_neutral
      "neutral"
    elsif feedback_negative
      "negative"
    end
  end
end

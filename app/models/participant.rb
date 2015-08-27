class Participant < ActiveRecord::Base
  belongs_to :trade
  belongs_to :user

  validates :trade, presence: true
  validates :user, presence: true
end

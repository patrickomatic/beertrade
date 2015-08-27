class Trade < ActiveRecord::Base
  has_many :participants
  has_many :users, through: :participants

  scope :open, ->{where(accepted_at: nil)}
  scope :closed, ->{where("accepted_at IS NOT NULL")}
end

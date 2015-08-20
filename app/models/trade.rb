class Trade < ActiveRecord::Base
  has_one :requester
  has_one :requestee

  validates :requester, presence: true
  validates :requestee, presence: true
end

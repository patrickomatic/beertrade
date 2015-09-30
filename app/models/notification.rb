class Notification < ActiveRecord::Base
  paginates_per 5

  belongs_to :user
  belongs_to :trade

  validates :user,      presence: true
  validates :message,   presence: true
  validates :trade,     presence: true
  validates :hashcode,  presence: true, uniqueness: true

  scope :unseen,    ->{ where("seen_at IS NOT NULL") }

  before_validation :create_hashcode


  def seen?
    seen_at?
  end


  def mark_as_seen!
    update_attributes(seen_at: Time.now)
  end

  
  def self.updated_shipping(participant)
    participant.other_participants.each do |p|
      Notification.transaction do
        Notification.create!(user: p.user, 
                             message: "#{participant.user} has shipped",
                             trade: p.trade)

        Reddit.pm(p.user, "#{participant.user} has shipped", 
                  'notifications/updated_shipping', participant: participant)
      end
    end
  end


  def self.send_invites(participants)
    participants.each do |p|
      Notification.transaction do
        Notification.create!(user: p.user, 
                             message: "you have been invited to a trade",
                             trade: p.trade)

        Reddit.pm(p.user, "/r/beertrade trade invite", 
                  'notifications/invite', participant: p)
      end
    end
  end


  def self.left_feedback(participant)
    other_username = participant.other_participant.user.to_s

    Notification.transaction do
      Notification.create!(user: participant.user, 
                           message: "#{other_username} has left you feedback",
                           trade: participant.trade)

      Reddit.pm(participant.user, "#{other_username} has left you feedback", 
                "notifications/left_feedback", participant: participant)
    end
  end


  private

    def create_hashcode
      self.hashcode = Digest::SHA1.hexdigest(user.id.to_s << message << trade.id.to_s)
    end
end

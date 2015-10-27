class User < ActiveRecord::Base
  has_many :participants
  has_many :trades, through: :participants
  has_many :notifications

  validates :username,          presence: true

  scope :top_traders, ->{ select("users.*, count(participants.id) AS participants_counts")
                          .joins(:participants)
                          .group("users.id")
                          .order("participants_counts DESC") }

  
  def self.find_by_username(username)
    User.where(["LOWER(username) = ?", username.downcase.strip]).first
  end


  def self.find_from_auth_hash(auth_hash)
    unless user = User.find_by(auth_uid: auth_hash.uid) 
      if user = User.find_by_username(auth_hash.info.name)
        user.update_attributes(auth_uid: auth_hash.uid, username: auth_hash.info.name)
      else
        user = User.create(auth_uid: auth_hash.uid, username: auth_hash.info.name)
      end
    end

    user
  end


  def unseen_notifications_count
    notifications.unseen.count
  end

  def positive_feedback_count
    participants.completed.with_positive_feedback.count
  end

  def neutral_feedback_count
    participants.completed.with_neutral_feedback.count
  end

  def negative_feedback_count
    participants.completed.with_negative_feedback.count
  end


  def flair_css_class
    return nil unless positive_feedback_count > 0
    "repLevel" << case positive_feedback_count
                  when 1..4;    "1"
                  when 5..9;    "2"
                  when 10..39;  "3"
                  when 40..99;  "4"
                  else;         "5"
                  end
  end


  def update_flair
    Reddit.set_flair(username, "#{reputation}% positive", flair_css_class) if reputation > 0
  end


  def check_if_moderator
    self.update_attributes(moderator: moderators.include?(self.username.downcase))
  end


  def to_param
    username
  end

  def to_s
    "/u/#{username}"
  end


  def reputation
    ((positive_feedback_count / (positive_feedback_count + negative_feedback_count).to_f) * 100).round
  rescue ZeroDivisionError, FloatDomainError
    0
  end


  def total_completed_trades
    # TODO should this not count neutral and negative?  perhaps evaluate where/how this is used
    participants.completed.count
  end


  private

    def moderators
      Rails.cache.fetch("beertrade_moderators", expires_in: 6.hours) do
        Reddit.get_moderator_info.map(&:name).map(&:downcase)
      end
    end
end

class User < ActiveRecord::Base
  has_many :participants
  has_many :trades, through: :participants

  validates :username, presence: true
  validates :positive_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :neutral_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :negative_feedback, presence: true, numericality: {greater_than_or_equal_to: 0}

  scope :by_feedback, -> { order(positive_feedback: :desc) }

  
  def self.find_by_username(username)
    User.where(["LOWER(username) = ?", username.downcase.strip]).first
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
    return unless reputation

    reddit_bot.subreddit_from_name("beertrade").set_flair(username, :user, 
                                                          text: "#{reputation}% positive", 
                                                          css_class: flair_css_class)
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


  private

    def reddit_bot
      Redd.it(:script, 
              Rails.application.secrets.bot_oauth_id, 
              Rails.application.secrets.bot_oauth_secret,
              Rails.application.secrets.bot_username, 
              Rails.application.secrets.bot_password).tap {|r| r.authorize!}
    end
end

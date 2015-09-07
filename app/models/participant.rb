class Participant < ActiveRecord::Base
  paginates_per 20

  belongs_to :trade
  belongs_to :user

  validates :trade, presence: true
  validates :user, presence: true

  scope :pending,           ->{ where(feedback: nil) }
  scope :completed,         ->{ where("feedback IS NOT NULL") }
  scope :not_yet_accepted,  ->{ where(accepted_at: nil) }


  def feedback_description
    if feedback_positive
      "positive"
    elsif feedback_neutral
      "neutral"
    elsif feedback_negative
      "negative"
    end
  end


  def other_participants
    trade.participants.reject {|p| p == self}
  end

  def other_participant
    other_participants.first
  end


  def send_invite
    reddit_bot.compose_message(self.user.username, "/r/beertrade trade invite", 
                               render_md_partial('participants/invite', 
                                                  participant: self, 
                                                  other_participant: other_participants.first))
  end


  private

    def reddit_bot
      Redd.it(:script, 
              Rails.application.secrets.bot_oauth_id, 
              Rails.application.secrets.bot_oauth_secret,
              Rails.application.secrets.bot_username, 
              Rails.application.secrets.bot_password).tap {|r| r.authorize!}
    end

    def render_md_partial(partial, locals={})
      action_view = ActionView::Base.new(Rails.configuration.paths["app/views"])
      action_view.class_eval do 
          include Rails.application.routes.url_helpers
          include ApplicationHelper

          def protect_against_forgery?
            false
          end
      end

      action_view.render(partial: partial, formats: [:md], locals: locals)
    end
end

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


  def other_participants
    trade.participants.reject {|p| p == self}
  end


  def invite
    reddit_bot.compose_message(self.user.username, "/r/beertrade trade invite", 
                               render_md_template('participants/invite', 
                                                  participant: self, 
                                                  other_participant: other_participants.first)
  end


  private

    def reddit_bot
      Redd.it(Rails.configuration.secrets.bot_oauth_id, 
              Rails.configuration.secrets.bot_oauth_secret, 
              Rails.configuration.secrets.bot_username, 
              Rails.configuration.secrets.bot_password).tap {|r| r.authorize!}
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

      action_view.render(partial: partial, format: :md, locals: locals)
    end
end

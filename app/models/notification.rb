class Notification < ActiveRecord::Base
  belongs_to :user
  validates :message, presence: true

  scope :for_user, ->(user) { where(user_id: user.id) }


  def seen?
    seen_at?
  end

  
  def self.updated_shipping(participant)
    username = participant.user.username

    participant.other_participants.each do |p|
      reddit_pm(p.user.username, "#{username} has shipped", 'notifications/updated_shipping')
      Notification.create!(user: p.user, message: "#{username} has shipped a package, here is the tracking number: #{participant.shipping_info}")
    end
  end


  def self.send_invites(participants)
    participants.each do |p|
      reddit_pm(p.user.username, "/r/beertrade trade invite", 'notifications/invite', participant: p)

      Notification.create!(user: p.user, message: "you have been invited to a trade", _path: trade_path(p.trade))
    end
  end


  def self.left_feedback(participant)
    username = participant.user.username
    reddit_pm(username, "#{username} has left you feedback", "notifications/left_feedback", participant: participant)
    Notification.create!(user: participant.user, message: "XXX")
  end


  private

    def self.reddit_pm(to, subject, partial, locals={})
      reddit_bot.compose_message(to, subject, render_md_partial(partial, locals))
    end


    def self.reddit_bot
      Redd.it(:script, 
              Rails.application.secrets.bot_oauth_id, 
              Rails.application.secrets.bot_oauth_secret,
              Rails.application.secrets.bot_username, 
              Rails.application.secrets.bot_password).tap {|r| r.authorize!}
    end


    def self.render_md_partial(partial, locals={})
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

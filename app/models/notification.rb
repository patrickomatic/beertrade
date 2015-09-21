class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :trade

  validates :user,    presence: true
  validates :message, presence: true
  validates :trade,   presence: true

  scope :for_user, ->(user) { where(user_id: user.id) }


  def seen?
    seen_at?
  end

  
  def self.updated_shipping(participant)
    participant.other_participants.each do |p|
      Notification.create!(user: p.user, 
                           message: "#{participant.user} has shipped a package, here is the tracking number: #{participant.shipping_info}",
                           trade: p.trade)

      reddit_pm(p.user.username, "#{participant.user} has shipped", 
                'notifications/updated_shipping', participant: participant)
    end
  end


  def self.send_invites(participants)
    participants.each do |p|
      Notification.create!(user: p.user, 
                           message: "you have been invited to a trade",
                           trade: p.trade)

      reddit_pm(p.user.username, "/r/beertrade trade invite", 
                'notifications/invite', participant: p)
    end
  end


  def self.left_feedback(participant)
    other_username = participant.other_participant.user.to_s

    Notification.create!(user: participant.user, 
                         message: "#{other_username} has left you feedback: #{participant.feedback}",
                         trade: participant.trade)

    reddit_pm(participant.user.username, "#{other_username} has left you feedback", 
              "notifications/left_feedback", participant: participant)
  end


  private

    def self.reddit_pm(to, subject, partial, locals={})
      reddit_bot.user_from_name(to).send_message(subject, render_md_partial(partial, locals))
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

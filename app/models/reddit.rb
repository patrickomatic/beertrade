class Reddit
  def self.pm(username, subject, partial, locals={})
    reddit_bot.user_from_name(username).send_message(subject, render_md_partial(partial, locals))
  end


  def self.set_flair(username, text, css_class)
    reddit_bot.subreddit_from_name("beertrade").set_flair(username, :user, text: text, css_class: css_class)
  end


  def self.get_moderator_info
    reddit_bot.subreddit_from_name("beertrade").moderator_about
  end


  private

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

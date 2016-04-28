class Reddit
  USER_AGENT = "/r/beertrade app, ran by /u/patrickomatic - please contact at patrick @ patrickomatic.com"

  def self.pm(username, subject, partial, locals={})
    username = username.strip
    object = if username.start_with?("/r/")
               reddit_bot.subreddit_from_name(username.gsub('/r/', ''))
             else
               reddit_bot.user_from_name(username)
             end

    object.send_message(subject, render_md_partial(partial, locals))
  end


  def self.set_flair(username, text, css_class)
    reddit_bot.subreddit_from_name("beertrade").set_flair(username.strip, :user, text, css_class)
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
              Rails.application.secrets.bot_password,
              user_agent: USER_AGENT).tap {|r| r.authorize!}
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

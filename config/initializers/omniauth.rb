Rails.application.config.middleware.use OmniAuth::Builder do
  provider :reddit, Rails.application.secrets.reddit_oauth_id, Rails.application.secrets.reddit_oauth_secret, scope: 'flair,identity,mysubreddits'
end

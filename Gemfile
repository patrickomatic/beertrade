source 'https://rubygems.org'

ruby '2.2.0'

gem 'rails'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'puma'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'autoprefixer-rails'
gem 'pg'

gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'kaminari-bootstrap'
gem 'kaminari'
gem 'sidekiq'
gem 'newrelic_rpm'

gem 'omniauth-oauth2', '~> 1.3.1'
gem 'omniauth-reddit', github: 'jackdempsey/omniauth-reddit'
gem 'redd', github: 'patrickomatic/redd', branch: 'list-moderators'
gem 'tracking_number'


group :production do
  gem 'rails_12factor'
  gem 'rollbar'
end

group :development do
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'byebug'
  gem 'spring'
  gem 'rspec-rails'
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry'
end

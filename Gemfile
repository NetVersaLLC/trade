source 'https://rubygems.org'
gem 'rails', '4.0.0.beta1'
gem 'mysql2'
group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'
  gem 'therubyracer', platforms: :ruby
  gem 'uglifier', '>= 1.0.3'
end
group :test do
  gem 'factory_girl_rails'
  gem "cucumber-rails"
  gem "rspec-rails", ">= 2.12.2"
  gem "database_cleaner", ">= 1.0.0.RC1"
  gem "email_spec", ">= 1.4.0"
  gem "launchy", ">= 2.2.0"
  gem "capybara", ">= 2.0.3"
end

group :development do
  gem 'capistrano'
  gem "capistrano-db-tasks", require: false
  gem 'rvm-capistrano'
  gem 'rb-fsevent'
  gem 'better_errors'
  gem 'binding_of_caller'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem "unicorn", ">= 4.3.1"
gem "haml-rails", ">= 0.4"
gem "html2haml", ">= 1.0.1", :group => :development
gem "quiet_assets", ">= 1.0.2", :group => :development
gem 'settingslogic'
gem 'rails-observers'

gem 'blogit', :git => "git@github.com:Fodoj/blogit.git", :branch => "rails4"

#AUTH
gem 'devise', :git => 'git://github.com/plataformatec/devise.git', :branch => "rails4"
gem 'omniauth-twitter'
gem 'omniauth-facebook'

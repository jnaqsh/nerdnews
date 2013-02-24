source 'https://rubygems.org'

gem 'rails', '3.2.12'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'select2-rails'
end

gem 'acts_as_paranoid'

gem 'active_link_to'

gem 'jquery-rails'
gem 'rails-i18n', git: 'https://github.com/iCEAGE/rails-i18n.git'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'debugger'
gem 'simple_form'
gem "cancan"
gem 'kaminari'
gem 'sunspot_rails'
gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development

gem 'RedCloth'
# plain formatter for redcloth
gem "red_cloth_formatters_plain", "~> 0.2.0"

# gem 'rack-mini-profiler'
gem 'jalalidate'
gem 'farsifu'
gem 'ancestry'

gem 'paperclip'
gem "paperclip-dropbox"

# progress_bar for reindexing sunspot
gem 'progress_bar'

gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-openid'
gem 'friendly_id'
gem 'therubyracer'
gem 'less-rails'
gem 'twitter-bootstrap-rails', git: "https://github.com/jnaqsh/twitter-bootstrap-rails.git"
gem 'acts_as_textcaptcha', git: "https://github.com/jnaqsh/acts_as_textcaptcha.git"
gem 'meta-tags', require: 'meta_tags'
gem 'rakismet'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'delayed_job_web'
gem 'whenever', :require => false

# mails execeptions to admin of site
gem 'exception_notification'

#for testing email in development mode
gem 'letter_opener', group: :development

gem 'twitter'

gem 'under_construction'

# Deploy with Capistrano
gem 'capistrano'

group :production do
  gem 'execjs'
  gem 'therubyracer'
  gem 'mysql2'
end

group :development do
  gem 'pry-rails'
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  gem 'faker'
  gem 'sunspot_test'
  gem 'guard-spork'
  gem 'launchy'
  gem 'rb-inotify', '~> 0.8.8', :require => false
  gem 'shoulda-matchers'
  gem 'poltergeist'
  gem 'webmock'
end

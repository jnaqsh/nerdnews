source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'

  # adding multiple fields in one text_field like tagging
  gem 'select2-rails', '~> 3.2.1'
end

# it adds a deleted_at column to database
gem 'acts_as_paranoid'

# it uses for making active class on menus
gem 'active_link_to'

# apparenty it's famous jquery lib for rails
gem 'jquery-rails'

# default label for i18n in rails
gem 'rails-i18n', git: 'https://github.com/iCEAGE/rails-i18n.git'

# encryption like passwords
gem 'bcrypt-ruby', '~> 3.0.0'

gem 'debugger'

gem 'simple_form', '~> 2.0.4'

# it uses for managing users in multiple roles
gem "cancan"

# for pagination
gem 'kaminari'

# a wrapper for apache solr in rails
gem 'sunspot_rails'
gem 'sunspot_solr'

# for textilize in rails
gem 'RedCloth'

# plain formatter for redcloth
gem "red_cloth_formatters_plain", "~> 0.2.0"

# for maintenance page in capistrano
gem "capistrano-maintenance"

# jalali (persian) date calendar
gem 'jalalidate'

# for some stuff in persian language like converting numbers to farsi
gem 'farsifu'

# it uses for ancestry things like nested comments
gem 'ancestry'

# it used for uploading files in rails
gem 'paperclip'
gem "paperclip-dropbox" # it's like a plugin for paperclip to use dropbox instead local

# progress_bar for reindexing sunspot
gem 'progress_bar'

# omniauth authentication gems
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-openid'

# the gem that uses in url naming
gem 'friendly_id'

gem 'therubyracer'
gem 'less-rails'

# rbootstrap is a gem for RTL twitter bootstrap
gem 'twitter-bootstrap-rails', git: "https://github.com/jnaqsh/twitter-bootstrap-rails.git"

# for textcaptcha in creating story
gem 'acts_as_textcaptcha', git: "https://github.com/jnaqsh/acts_as_textcaptcha.git"

# it uses for meta tags in html like description tag
gem 'meta-tags', require: 'meta_tags'

# it's famous akismet in rails, for fighting with spams
gem 'rakismet'

gem 'daemons'

# it's cron in rails
gem 'whenever', :require => false

# gems for delaying a job like sending mail
gem 'delayed_job_web'
gem 'delayed_job_active_record'

# mails execeptions to admin of site
gem 'exception_notification'

# gem for twitting story
gem 'twitter'

# Deploy with Capistrano
gem 'capistrano'

# for creating json api
gem 'rabl'
gem 'oj' # Also add either `oj` or `yajl-ruby` as the JSON parser

# To send HTML mails
gem 'roadie'

group :production do
  gem 'execjs'
  gem 'therubyracer'
  gem 'mysql2'
end

group :development do
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller'

  # it warns about eager loading and just for development mode
  gem 'bullet'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-nav'
end

group :test do
  gem 'factory_girl_rails'
  gem "capybara", "~> 2.1.0"
  gem 'guard-rspec'
  gem 'faker'
  gem 'sunspot_test'
  # gem 'guard-spork'
  gem 'guard-zeus'
  gem 'launchy'
  # gem 'rb-inotify', '~> 0.9', :require => false
  gem 'shoulda-matchers'
  gem "poltergeist", "~> 1.3.0"
  gem 'webmock'
end

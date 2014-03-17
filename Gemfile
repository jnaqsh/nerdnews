source 'https://rubygems.org'

gem 'rails', '4.0.4'

# Gems used only for assets and not required
# in production environments by default.
gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'

# Gem that are removed from Rails 4. I'll added them back
# to make it easier for migration
gem 'activerecord-deprecated_finders'

# adding multiple fields in one text_field like tagging
gem 'select2-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# it adds a deleted_at column to database
gem 'paranoia', '~> 2.0'

# it uses for making active class on menus
gem 'active_link_to'

# apparenty it's famous jquery lib for rails
gem 'jquery-rails'
gem 'jquery-ui-rails'

# default label for i18n in rails
gem 'rails-i18n', git: 'https://github.com/iCEAGE/rails-i18n.git'

# encryption like passwords
gem 'bcrypt-ruby', '~> 3.1.2'

gem "debugger", "~> 1.6.6"

gem 'simple_form', '~> 3.0.0'

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
# gem "capistrano-maintenance"

# jalali (persian) date calendar
gem 'jalalidate'

# for some stuff in persian language like converting numbers to farsi
gem 'farsifu'

# it uses for ancestry things like nested comments
gem 'ancestry'

# it used for uploading files in rails
gem 'paperclip', "= 3.5.4"
gem "paperclip-dropbox", "= 1.2.0" # it's a plugin for paperclip to use dropbox instead local

# progress_bar for reindexing sunspot (http://answer.techwikihow.com/574579/sunspot-reindex-error-progress_bar-related.html) TODO: replace original progress_bar when it gets fixed
gem 'progress_bar', github: 'fivedigit/progress_bar'

# omniauth authentication gems
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'omniauth-openid'
gem 'omniauth-browserid'

# the gem that uses in url naming
gem 'friendly_id'

# Compile less files
gem 'therubyracer'
gem 'less-rails', '2.3.3'

# rbootstrap is a gem for RTL twitter bootstrap
gem 'twitter-bootstrap-rails', github: "jnaqsh/twitter-bootstrap-rails", branch: "new_version", ref: "64e8b"

# for textcaptcha in creating story
gem 'acts_as_textcaptcha', git: "https://github.com/jnaqsh/acts_as_textcaptcha.git"

# it uses for meta tags in html like description tag
gem 'meta-tags', require: 'meta_tags'

# it's famous akismet in rails, for fighting with spams
gem 'rakismet'

gem 'daemons'

# it's cron in rails
gem "whenever", "~> 0.9.0", :require => false

# gems for delaying a job like sending mail
gem 'delayed_job_web'
gem 'delayed_job_active_record'

# mails execeptions to admin of site
gem 'exception_notification'

# gem for twitting story
gem 'twitter'

# for creating json api
gem 'rabl'
gem 'oj' # Also add either `oj` or `yajl-ruby` as the JSON parser

# OAuth2 support
gem 'doorkeeper', '~> 1.0.0.rc1'

# To send HTML mails
gem 'roadie'

group :production do
  gem 'execjs'
  gem 'mysql2'
end

group :development do
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller'

  # it warns about eager loading and just for development mode
  gem 'bullet'

  # Deploy with Capistrano
  gem 'capistrano-rails', '~> 1.0.0'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler', '~> 1.1.2'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'pry-nav'
  # Formatter for rspec
  gem 'fuubar'
end

group :test do
  gem 'factory_girl_rails'
  gem "capybara", "~> 2.1.0"
  gem 'guard-rspec'
  gem 'faker'
  gem 'sunspot-rails-tester'
  gem 'guard-zeus'
  gem 'launchy'
  # gem 'rb-inotify', '~> 0.9', :require => false
  gem 'shoulda-matchers'
  gem "poltergeist", "~> 1.4.0"
  gem 'webmock'
  gem 'database_cleaner'
end

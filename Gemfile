source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails', git: "https://github.com/jnaqsh/twitter-bootstrap-rails.git"
end

gem 'jquery-rails'
gem 'rails-i18n', git: 'https://github.com/iCEAGE/rails-i18n.git'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'debugger'
gem 'simple_form'
gem "cancan"
gem 'kaminari'
gem 'sunspot_rails'
gem 'RedCloth'
gem 'rack-mini-profiler'
gem 'jalalidate'
gem 'farsifu'
gem 'ancestry'
gem 'paperclip'
gem 'omniauth-github'
gem 'omniauth-openid'

group :production do
  gem 'execjs'
  gem 'therubyracer'
  gem 'mysql2'
end

group :development do
  gem 'sunspot_solr' # optional pre-packaged Solr distribution for use in development
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :test do
  gem 'capybara'
  gem 'guard-rspec'
  gem 'faker'
  gem 'sunspot_test'
  gem 'guard-spork'
  gem 'launchy'
  gem 'rb-inotify', '~> 0.8.8'
  gem 'shoulda-matchers'
  gem 'poltergeist'
end

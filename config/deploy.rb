# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'nerdnews'
set :repo_url, 'git@github.com:jnaqsh/nerdnews.git'

# Default branch is :master
#ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/deployer/apps/nerdnews'
set :rails_env, "production"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application_configs.yml config/sunspot.yml config/textcaptcha.yml config/dropbox.yml config/dropbox_backup.yml config/twitter.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system db/db_backup solr/production solr/pids}

# Default value for default_env is {}
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
  after :publishing, 'delayed_job:restart'
  after :publishing, 'solr:restart'

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :'bin/rake', 'tmp:clear'
      end
    end
  end
end

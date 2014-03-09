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
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/application_configs.yml config/sunspot.yml config/textcaptcha.yml config/dropbox.yml config/dropbox_backup.yml config/twitter.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system db/db_backup solr/production solr/pids}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

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

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'tmp:clear'
      end
    end
  end

end

namespace :solr do

  %w[start stop].each do |command|
    desc "#{command} solr"
    task command do
      on roles(:app) do
        solr_pid = "#{shared_path}/solr/pids/#{fetch(:rails_env)}/sunspot-solr-#{fetch(:rails_env)}.pid"
        if command == "start" or (test "[ -f #{solr_pid} ]" and test "kill -0 $( cat #{solr_pid} )")
          within current_path do
            with rails_env: fetch(:rails_env) do
              execute :rake, "sunspot:solr:#{command}"
            end
          end
        end
      end
    end
  end

  desc "restart solr"
  task :restart do
    invoke 'solr:stop'
    invoke 'solr:start'
  end

  after 'deploy:finished', 'solr:restart'

  desc "reindex the whole solr database"
  task :reindex do
    invoke 'solr:stop'
    on roles(:app) do
      execute :rm, "-rf #{shared_path}/solr/#{fetch(:rails_env)}/*"
    end
    invoke 'solr:start'
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          info "Reindexing Solr database"
          execute :rake, 'sunspot:solr:reindex[,,true]'
        end
      end
    end
  end
end

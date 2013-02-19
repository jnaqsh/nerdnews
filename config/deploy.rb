require "bundler/capistrano"
require "delayed/recipes"

server "server.jnaqsh.com", :web, :app, :db, primary: true

set :application, "nerdnews"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

# rbenv
set :default_environment, {
  "PATH" => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH",
}

set :scm, "git"
set :repository, "https://github.com/jnaqsh/#{application}.git"
set :branch, "master"

set :rails_env, "production" #added for delayed job

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:start", "solr:start"
after "deploy:stop", "solr:stop"
after "deploy:restart", "delayed_job:restart"

namespace :deploy do
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  desc 'Start Application'
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /opt/nginx/sites-enabled/#{application}"
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/db"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    put File.read("config/application_configs.example.yml"), "#{shared_path}/config/application_configs.yml"
    put File.read("config/sunspot.example.yml"), "#{shared_path}/config/sunspot.yml"
    put File.read("config/textcaptcha.example.yml"), "#{shared_path}/config/textcaptcha.yml"
    put File.read("config/dropbox.example.yml"), "#{shared_path}/config/dropbox.yml"
    put File.read("config/twitter.example.yml"), "#{shared_path}/config/twitter.yml"
    FileUtils.touch "#{shared_path}/db/under_construction_mails.txt"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/application_configs.yml #{release_path}/config/application_configs.yml"
    run "ln -nfs #{shared_path}/config/sunspot.yml #{release_path}/config/sunspot.yml"
    run "ln -nfs #{shared_path}/config/textcaptcha.yml #{release_path}/config/textcaptcha.yml"
    run "ln -nfs #{shared_path}/config/twitter.yml #{release_path}/config/twitter.yml"
    run "ln -nfs #{shared_path}/config/dropbox.yml #{release_path}/config/dropbox.yml"
    run "ln -nfs #{shared_path}/db/under_construction_mails.txt #{release_path}/db/under_construction_mails.txt"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end

  before "deploy", "deploy:check_revision"

  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake paperclip:refresh:missing_styles"
  end

  after "deploy:migrate", "deploy:build_missing_paperclip_styles"
end

namespace :deploy do
  task :setup_solr_data_dir do
    run "mkdir -p #{shared_path}/solr/data"
  end
end

namespace :solr do
  desc "start solr"
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr start --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "stop solr"
  task :stop, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec sunspot-solr stop --port=8983 --data-directory=#{shared_path}/solr/data --pid-dir=#{shared_path}/pids"
  end
  desc "reindex the whole database"
  task :reindex, :roles => :app do
    stop
    run "rm -rf #{shared_path}/solr/data"
    start
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake sunspot:solr:reindex"
  end
end

after 'deploy:setup', 'deploy:setup_solr_data_dir'

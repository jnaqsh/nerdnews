# Learn more: http://github.com/javan/whenever
set :output, File.join(path, "log", "cron.log")

every 1.day, :at => '2:00 am' do
  runner "Story.hide_negative_stories"
  runner "User.promote_users"
  runner "Comment.hide_negative_comments"
end

every 1.day do
  command "cd #{path} && RAILS_ENV=#{environment} backup perform --trigger db_backup --config_file config/backup.rb --data-path db --log-path log --tmp-path tmp"
end

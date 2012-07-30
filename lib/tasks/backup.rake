namespace :db do
  desc "backup mysql database and paperclip data and save it in ~/dbs"
  task :backup => :environment do
    CONFIG = Rails.configuration.database_configuration
    DB = CONFIG[Rails.env]["database"]
    USER = CONFIG[Rails.env]["username"]
    PW = CONFIG[Rails.env]["password"]

    today_s = Date.today().to_s
    yesterday_s = (Date.today()-(2)).to_s

    TODAY_BACKUP = "#{ENV["HOME"]}/dbs/#{today_s}-#{DB}.sql"

    directory_name = "#{ENV['HOME']}/dbs"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)

    system "/usr/bin/mysqldump --user=#{USER} --password=#{PW} #{DB} > ~/dbs/#{today_s}-#{DB}.sql"
    if File.exist? "#{Rails.root}/public/system"
      system "/bin/tar zcfv ~/dbs/#{today_s}-#{DB}.tgz #{TODAY_BACKUP} #{Rails.root}/public/system"
      File.unlink(TODAY_BACKUP)
    end
  end
end

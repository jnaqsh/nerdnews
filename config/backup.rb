database_yml = File.expand_path('../../config/database.yml',  __FILE__)
dropbox_yml = File.expand_path('../../config/dropbox_backup.yml',  __FILE__)

RAILS_ENV    = ENV['RAILS_ENV'] || 'development'

require 'yaml'

config = YAML.load_file(database_yml)
dropbox_config = YAML.load_file(dropbox_yml)

Backup::Model.new(:db_backup, "Backup database") do
  database MySQL do |db|
    # To dump all databases, set `db.name = :all` (or leave blank)
    db.name               = config[RAILS_ENV]["database"]
    db.username           = config[RAILS_ENV]["username"]
    db.password           = config[RAILS_ENV]["password"]
    db.host               = config[RAILS_ENV]["host"]
    db.additional_options = ["--quick", "--single-transaction"]
  end

  compress_with Bzip2

  store_with Dropbox do |db|
    db.api_key    = dropbox_config[RAILS_ENV]["app_key"]
    db.api_secret = dropbox_config[RAILS_ENV]["app_secret"]
    # Dropbox Access Type
    # The default value is :app_folder
    # Change this to :dropbox if needed
    db.path       = '/'
    db.keep       = 30
  end

  store_with Local do |local|
    local.path = 'db/'
    local.keep = 15
  end

  notify_by Mail do |mail|
    mail.on_success           = true
    mail.on_warning           = true
    mail.on_failure           = true

    mail.delivery_method      = :sendmail
    mail.from                 = 'backup@nerdnews.ir'
    mail.to                   = 'iceage2098@gmail.com'

    mail.sendmail             = '/usr/sbin/sendmail'
    mail.sendmail_args        = '-i -t'
  end
end

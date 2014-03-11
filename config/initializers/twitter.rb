require 'twitter'

TWITTER_CONF = YAML.load(File.read(Rails.root.join('config', 'twitter.yml')))[Rails.env]

require 'twitter'

twitter_config = YAML.load(File.read(Rails.root.join('config', 'twitter.yml')))[Rails.env]

client = Twitter::REST::Client.new do |config|
  config.consumer_key =twitter_config['consumer_key']
  config.consumer_secret = twitter_config['consumer_secret']
  config.oauth_token = twitter_config['oauth_token']
  config.oauth_token_secret = twitter_config['oauth_token_secret']
end

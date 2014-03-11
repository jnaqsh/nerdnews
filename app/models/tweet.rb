require 'open-uri'

class Tweet
  def self.tweet(title, link)
    tweet_desc = title
    shrunk_url = tiny_url(134 - tweet_desc.length, link)
    if tweet_desc.length > 134 - shrunk_url.length
      tweet_desc = tweet_desc[0...(134 - shrunk_url.length)] + '...'
    end
    tweet = "#{tweet_desc} #{shrunk_url}"
    client = setup
    client.update tweet
  end

  def self.tiny_url(available_length, url)
    return url if url.length < available_length
    string = "http://is.gd/api.php?longurl=" + CGI::escape(url)
    open(string).read.strip
  rescue StandardError => e
    puts "Error in tiny_url: #{e.message}\n#{e.backtrace}"
  end

  def self.setup
    Twitter::REST::Client.new do |config|
      config.consumer_key = TWITTER_CONF['consumer_key']
      config.consumer_secret = TWITTER_CONF['consumer_secret']
      config.oauth_token = TWITTER_CONF['oauth_token']
      config.oauth_token_secret = TWITTER_CONF['oauth_token_secret']
    end
  end

  private_class_method :tiny_url, :setup
end

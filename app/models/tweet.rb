require 'open-uri'

class Tweet
  def self.tweet(title, link)
    tweet_desc = title
    shrunk_url = Tweet.tiny_url(134 - tweet_desc.length, link)
    if tweet_desc.length > 134 - shrunk_url.length
      tweet_desc = tweet_desc[0...(134 - shrunk_url.length)] + '...'
    end
    tweet = "#{tweet_desc} #{shrunk_url}"
    Twitter.update tweet
  end

  def self.tiny_url(available_length, url)
    return url if url.length < available_length
    string = "http://is.gd/api.php?longurl=" + CGI::escape(url)
    open(string).read.strip
  rescue StandardError => e
    puts "Error in tiny_url: #{e.message}\n#{e.backtrace}"
  end
end

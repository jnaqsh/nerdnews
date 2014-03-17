require 'openid/store/filesystem'
require 'omniauth-openid'

Rails.application.config.middleware.use OmniAuth::Builder do
  # Secret keys should be added to config/application_configs.yml
  # Copy config/application_configs_sample.yml and add your keys
  provider :github, CONFIG[:github_key], CONFIG[:github_secret]
  #provider :facebook, CONFIG[:facebook_key], CONFIG[:facebook_secret]
  provider :twitter, CONFIG[:twitter_key], CONFIG[:twitter_secret]
  provider :openid, store: OpenID::Store::Filesystem.new('/tmp'), name: 'myopenid', identifier: 'myopenid.com'
  provider :openid, store: OpenID::Store::Filesystem.new('/tmp'), name: 'google', identifier: 'https://www.google.com/accounts/o8/id'
  provider :openid, store: OpenID::Store::Filesystem.new('/tmp'), name: 'yahoo', identifier: 'https://yahoo.com'
  provider :browser_id
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

require 'openid/store/filesystem'
require 'omniauth-openid'

Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :github, APP_CONFIG["71e0c93b5d7a01a048de
# "], APP_CONFIG["16f030018ba23193651e3ab9fabbc4585f7cb2ea"]
    provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'myopenid', :identifier => 'myopenid.com'
    provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
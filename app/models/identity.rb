class Identity < ActiveRecord::Base
  attr_accessible :provider, :uid

  belongs_to :user

  PROVIDERS = ['myopenid', 'google', 'twitter', 'github', 'yahoo']

  def self.providers
    PROVIDERS
  end
end

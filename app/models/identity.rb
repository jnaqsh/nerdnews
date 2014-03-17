# == Schema Information
#
# Table name: identities
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Identity < ActiveRecord::Base
  belongs_to :user

  PROVIDERS = ['browser_id', 'myopenid', 'google', 'twitter', 'github', 'yahoo']

  def self.providers
    PROVIDERS
  end
end

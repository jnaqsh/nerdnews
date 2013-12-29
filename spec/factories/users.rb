# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  full_name              :string(255)
#  email                  :string(255)
#  password_digest        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  comments_count         :integer          default(0)
#  stories_count          :integer          default(0)
#  user_rate              :integer          default(0)
#  website                :string(255)
#  favorite_tags          :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  slug                   :string(255)
#  email_visibility       :boolean          default(TRUE)
#

require 'faker'

FactoryGirl.define do
  factory :raw_user, class: User do
    full_name { Faker::Lorem.characters(8) }
    email { Faker::Internet.email }
    website { Faker::Internet.domain_name }
    password 'secret'
    password_confirmation 'secret'

    factory :user do
      after(:create) {|u| u.roles.replace Array(Role.find_by_name("new_user") || create(:role)) }
    end

    factory :approved_user do
      after(:create) {|u| u.roles.replace Array(Role.find_by_name("approved") || create(:approved_role)) }
    end

    factory :founder_user do
      after(:create) {|u| u.roles.replace Array(Role.find_by_name("founder") || create(:founder_role)) }
    end
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :message do
    subject Faker::Lorem.characters(20)
    message Faker::Lorem.characters(100)
    unread true

    factory :message_with_user do
      after(:build) do |u|
        u.sender = create(:user)
        u.receiver = create(:user)
      end
    end
  end
end

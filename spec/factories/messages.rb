# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :message do
    subject Faker::Lorem.characters(20)
    message Faker::Lorem.characters(100)
    unread true
    sender_id 1
    receiver_id 2
  end
end

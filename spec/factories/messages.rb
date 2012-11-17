# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :message do
    subject Faker::Lorem.words
    message Faker::Lorem.paragraph
    unread true
    sender_id 1
    receiver_id 2
  end
end

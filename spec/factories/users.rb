require 'faker'

FactoryGirl.define do
  factory :user do |u|
    u.full_name { Faker::Lorem.characters(7) }
    u.email { Faker::Internet.email }
    u.password 'secret'
    u.password_confirmation 'secret'
  end
end
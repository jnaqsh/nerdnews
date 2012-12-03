require 'faker'

FactoryGirl.define do
  factory :comment do |c|
    c.name    { Faker::Name.name }
    c.email   { Faker::Internet.email }
    c.content { Faker::Lorem.paragraph }
    c.user_ip { '1.2.3.4' }
    c.user_agent { 'Mozilla/5.0' }
    c.referrer { 'http://localhost' }

    factory :comment_reply do |c|
      c.ancestry 1
    end
  end
end
require 'faker'

FactoryGirl.define do
  factory :comment do |c|
    c.name    { Faker::Name.name }
    c.email   { Faker::Internet.email }
    c.content { Faker::Lorem.paragraph }

    factory :comment_reply do |c|
      c.ancestry 1
    end
  end
end
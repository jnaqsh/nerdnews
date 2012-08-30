require 'faker'

FactoryGirl.define do
  factory :story do |s|
    s.title   { Faker::Lorem.characters(10)}
    s.content { Faker::Lorem.paragraph }
  end

  factory :approved_story, parent: :story do |s|
    s.publish_date { mark_as_published }
  end
end
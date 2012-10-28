require 'faker'

FactoryGirl.define do
  factory :story do |s|
    s.title   { Faker::Lorem.characters(11)}
    s.content { Faker::Lorem.paragraph }
    s.publish_date nil
  end
  
  factory :approved_story, parent: 'story' do |s|
    s.publish_date { Time.now }
  end
end
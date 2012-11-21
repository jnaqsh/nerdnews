require 'faker'

FactoryGirl.define do
  factory :story do
    title   { Faker::Lorem.characters(11)}
    content { Faker::Lorem.characters(260) }
    publish_date nil

    after(:build) do |story|
      story.textcaptcha
      story.spam_answer = "four"
    end

    factory :approved_story do
      publish_date { Time.now }
    end
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do |v|
    v.user_id 1
    v.story_id 1
    v.rating_id 1
  end
end

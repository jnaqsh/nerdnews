require 'faker'
FactoryGirl.define do
  factory :rating do |r|
    r.name { Faker::Lorem.characters(5) }
    r.weight 1

    factory :negative_rating do |r|
      r.name { Faker::Lorem.characters(5) }
      r.weight -1
    end
  end
end

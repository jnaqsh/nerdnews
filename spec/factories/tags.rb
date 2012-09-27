require 'faker'
FactoryGirl.define do
  factory :tag do |t|
    t.name Faker::Lorem.characters(5)
    t.thumbnail File.open('app/assets/images/rails.png')
  end
end
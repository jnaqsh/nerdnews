require 'faker'

FactoryGirl.define do
  factory :user do |u|
    u.full_name { Faker::Lorem.characters(8) }
    u.email { Faker::Internet.email }
    u.website { Faker::Internet.domain_name }
    u.password 'secret'
    u.password_confirmation 'secret'

    factory :admin_user do
      association :role_ids, factory: :admin
    end

    factory :manager_user do
      association :role_ids, factory: :manager
    end
  end
end
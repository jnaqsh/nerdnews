require 'faker'

FactoryGirl.define do
  factory :user do |u|
    u.full_name { Faker::Lorem.characters(8) }
    u.email { Faker::Internet.email }
    u.website { Faker::Internet.domain_name }
    u.password 'secret'
    u.password_confirmation 'secret'

    factory :new_user do
      association :role_ids, factory: :new_user_role
    end

    factory :approved_user do
      association :role_ids, factory: :approved_role
    end

    factory :founder_user do
      association :role_ids, factory: :founder_role
    end
  end
end

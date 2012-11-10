require 'faker'

FactoryGirl.define do
  factory :raw_user, class: User do
    full_name { Faker::Lorem.characters(8) }
    email { Faker::Internet.email }
    website { Faker::Internet.domain_name }
    password 'secret'
    password_confirmation 'secret'

    factory :user do
      after(:create) {|u| u.roles << (Role.find_by_name("new_user") or create(:role)) }
    end

    factory :approved_user do
      after(:create) {|u| u.roles << (Role.find_by_name("approved") or create(:approved_role)) }
    end

    factory :founder_user do
      after(:create) {|u| u.roles << (Role.find_by_name("founder") or create(:founder_role)) }
    end
  end
end

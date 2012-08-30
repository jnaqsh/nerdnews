FactoryGirl.define do
  factory :admin, class: Role do |role|
    role.name 'admin'
  end

  factory :manager, class: Role do |role|
    role.name 'manager'
  end

  factory :regular_user, class: Role do |role|
    role.name 'user'
  end
end
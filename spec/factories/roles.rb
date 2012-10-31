FactoryGirl.define do
  factory :founder_role, class: Role do |role|
    role.name 'founder'
  end

  factory :approved_role, class: Role do |role|
    role.name 'approved'
  end

  factory :new_user_role, class: Role do |role|
    role.name 'new_user'
  end
end

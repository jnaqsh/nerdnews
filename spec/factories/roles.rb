FactoryGirl.define do
  factory :role do
    name "new_user"

    factory :founder_role, class: Role do
      name 'founder'
    end

    factory :approved_role, class: Role do
      name 'approved'
    end
  end
end

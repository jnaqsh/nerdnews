# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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

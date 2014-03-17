# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  rating_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  voteable_id   :integer
#  voteable_type :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vote do |v|
    v.user_id 1
    v.rating_id 1
  end
end

# == Schema Information
#
# Table name: ratings
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  weight        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rating_target :string(255)
#

require 'faker'
FactoryGirl.define do
  factory :rating do |r|
    r.name { Faker::Lorem.characters(5) }
    r.weight 1
    r.rating_target 'stories'

    factory :rating_comments do |r|
      r.rating_target 'comments'
    end

    factory :negative_rating do |r|
      r.name { Faker::Lorem.characters(5) }
      r.weight -1
      
      factory :negative_comments do |r|
        r.rating_target 'comments'
      end
    end
  end
end

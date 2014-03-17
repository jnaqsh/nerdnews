# == Schema Information
#
# Table name: stories
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  content              :text
#  publish_date         :datetime
#  user_id              :integer
#  slug                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  comments_count       :integer          default(0)
#  view_counter         :integer          default(0)
#  positive_votes_count :integer          default(0)
#  negative_votes_count :integer          default(0)
#  source               :string(255)
#  publisher_id         :integer
#  total_point          :integer          default(0)
#  hide                 :boolean          default(FALSE)
#  deleted_at           :datetime
#  remover_id           :integer
#

require 'faker'

FactoryGirl.define do
  factory :story do
    title   { Faker::Lorem.characters(11)}
    content { Faker::Lorem.paragraph(15) }
    publish_date nil

    after(:build) do |story|
      story.textcaptcha
      story.spam_answer = "four"
    end

    factory :approved_story do
      publish_date { Time.now }
      after(:build){ |s| s.publisher = create(:approved_user)}
    end
  end
end

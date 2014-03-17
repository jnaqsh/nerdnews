# == Schema Information
#
# Table name: messages
#
#  id          :integer          not null, primary key
#  sender_id   :integer
#  receiver_id :integer
#  subject     :string(255)
#  message     :text
#  unread      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl
require 'faker'

FactoryGirl.define do
  factory :message do
    subject Faker::Lorem.characters(20)
    message Faker::Lorem.characters(100)
    unread true

    factory :message_with_user do
      after(:build) do |u|
        u.sender = create(:user)
        u.receiver = create(:user)
      end
    end
  end
end

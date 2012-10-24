# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    user_id 1
    reciver_id 1
    subject "MyString"
    message "MyText"
    unread true
  end
end

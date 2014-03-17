# == Schema Information
#
# Table name: comments
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  content              :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  story_id             :integer
#  user_id              :integer
#  email                :string(255)
#  ancestry             :string(255)
#  website              :string(255)
#  positive_votes_count :integer          default(0)
#  negative_votes_count :integer          default(0)
#  user_ip              :string(255)
#  user_agent           :string(255)
#  referrer             :string(255)
#  approved             :boolean          default(TRUE)
#  total_point          :integer          default(0)
#  deleted_at           :datetime
#

require 'faker'
require 'webmock'
include WebMock::API

FactoryGirl.define do
  factory :comment do |c|

    before(:create) do |c|
      if c.name == 'viagra-test-123'
        stub_request(:post, /.*akismet.com\/.*/)
          .with(body: hash_including({ "comment_author" => "viagra-test-123" }))
          .to_return(status: 200, body: "true", headers: {'Content-Length'=> 4 })
      else
        stub_request(:post, /.*akismet.com\/.*/)
          .to_return(status: 200, body: "false", headers: {'Content-Length'=> 4 })
      end
    end

    c.name    { Faker::Name.name }
    c.email   { Faker::Internet.email }
    c.content { Faker::Lorem.paragraph }
    c.user_ip { '1.2.3.4' }
    c.user_agent { 'Mozilla/5.0' }
    c.referrer { 'http://localhost' }

    after(:build) do |comment|
      comment.textcaptcha
      comment.spam_answer = "four"
    end

    factory :comment_reply do
      after(:build) {|c| c.ancestry = create(:comment).id}
      after(:build) {|c| c.story = create(:approved_story) }
    end
  end
end

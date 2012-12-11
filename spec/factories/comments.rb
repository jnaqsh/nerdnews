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

    factory :comment_reply do |c|
      c.ancestry 1
    end
  end
end
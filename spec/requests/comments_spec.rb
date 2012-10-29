# encoding: utf-8
require 'spec_helper'

describe "Comments" do
  let(:user)  { FactoryGirl.create :user }
  let(:story) { FactoryGirl.create :story }
  # let(:comment) { FactoryGirl.create :comment, story_id: story.id, user_id: user.id }

  # before do
  #   comment = FactoryGirl.create :comment, story_id: story.id, user_id: user.id
  # end

  it "sends and reply to a comment" do
    visit new_story_comment_path story.id
    fill_in "نام", with: user.full_name
    fill_in "ایمیل", with: user.email
    fill_in "وب‌سایت", with: user.website
    fill_in "دیدگاه", with: Faker::Lorem.paragraph
    click_button "ایجاد"
    page.should have_content "موفقیت"
    current_path.should eq(story_path story)
    click_link "پاسخ"
    fill_in "نام", with: user.full_name
    fill_in "ایمیل", with: user.email
    fill_in "وب‌سایت", with: user.website
    fill_in "دیدگاه", with: Faker::Lorem.paragraph
    click_button "ایجاد"
    page.should have_content("موفقیت")
  end

  it "Sends email to original author when replies" do
    comment = FactoryGirl.create :comment, story_id: story.id, user_id: user.id
    visit story_path story
    click_link "پاسخ"
    fill_in "نام", with: user.full_name
    fill_in "ایمیل", with: user.email
    fill_in "دیدگاه", with: Faker::Lorem.paragraph
    click_button 'ایجاد'
    last_email.to.should include(comment.email)
  end
end

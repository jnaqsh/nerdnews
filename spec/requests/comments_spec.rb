# encoding: utf-8
require 'spec_helper'

describe "Comments" do
  let(:user)  { FactoryGirl.create :user }
  let(:story) { FactoryGirl.create :story }

  it "sends a comment" do
    visit new_story_comment_path story.id
    fill_in "نام", with: user.full_name
    fill_in "ایمیل", with: user.email
    fill_in "دیدگاه", with: Faker::Lorem.paragraph
    click_button "ایجاد"
    page.should have_content "موفقیت"
    current_path.should eq(story_path story.id)
  end

  it "replies to a comment" do
    comment = FactoryGirl.create :comment, story_id: story.id, user_id: user.id
    visit story_path story
    click_link "پاسخ"
    current_url.should eq(new_story_comment_url story.id, parent_id: comment.id)
    fill_in "نام", with: user.full_name
    fill_in "ایمیل", with: user.email
    fill_in "دیدگاه", with: Faker::Lorem.paragraph
    click_button "ایجاد"
    page.should have_content "موفقیت"
    current_path.should eq(story_path story.id)
  end
end

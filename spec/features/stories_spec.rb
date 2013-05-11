# encoding: utf-8
require 'spec_helper'

describe "Stories" do

  it "raise the counter by one when visiting a page" do
    story = FactoryGirl.create(:approved_story)
    expect {
      visit story_url story
      }.to change { story.reload.view_counter }.by(1)
  end

  describe "Post a Story" do
    context "as an unknown user or new user" do

      before do
        visit root_url
        find('.page-header').click_link "جدید"
        current_path.should eq(new_story_path)
      end

      it 'posts the story and put it on queue' do
        fill_in "story_title", with: Faker::Lorem.characters(10)
        fill_in "story_content", with: Faker::Lorem.characters(260)
        fill_in "story_spam_answer", with: "four"
        click_button "ایجاد"
        page.should have_content("موفقیت") and have_content("مدیرها")
        Story.last.publish_date.should be_nil
      end

      it 'doesn\'t post story with wrong spam answer' do
        fill_in "story_title", with: Faker::Lorem.characters(10)
        fill_in "story_content", with: Faker::Lorem.paragraph
        fill_in "story_spam_answer", with: "ten"
        click_button "ایجاد"
        page.should have_content(
          I18n.t("activerecord.errors.models.story.attributes.spam_answer.incorrect_answer"))
      end

      it 'doesn\'t need fill spam answer after login with approved user' do
        fill_in "story_title", with: Faker::Lorem.characters(10)
        fill_in "story_content", with: Faker::Lorem.paragraph
        fill_in "story_spam_answer", with: "ten"
        click_button "ایجاد"
        page.should have_content(
          I18n.t("activerecord.errors.models.story.attributes.spam_answer.incorrect_answer"))
        user = FactoryGirl.create(:approved_user)
        login user
        find('.page-header').click_link "جدید"
        current_path.should eq(new_story_path)
        page.should have_no_selector('story_spam_answer')
        fill_in "story_title", with: Faker::Lorem.characters(10)
        fill_in "story_content", with: Faker::Lorem.characters(260)
        click_button 'ایجاد'
        page.should have_content("موفقیت") and have_content('مدیرها') and have_content('منتشرنشده')
        Story.last.publish_date.should be_nil
      end

      it 'gets preview' do
        content = Faker::Lorem.paragraph
        fill_in "عنوان", with: Faker::Lorem.characters(10)
        fill_in "محتوا", with: content
        click_button 'پیش‌نمایش'
        page.should have_selector 'blockquote', text: content
        page.should have_content 'هشدار'
      end
    end
  end
end

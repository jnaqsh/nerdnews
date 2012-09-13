# encoding: utf-8
require 'spec_helper'

describe "Stories" do
  describe "Post a Story" do
    context "as an unknown user" do
      
      before do 
        visit root_url
        click_link "جدید"
      end

      it 'posts the story and put it on queue' do
        current_path.should eq(new_story_path)
        fill_in "عنوان", with: Faker::Lorem.characters(10)
        fill_in "محتوا", with: Faker::Lorem.paragraph
        click_button "ایجاد"
        page.should have_content("موفقیت")
      end

      it 'gets preview' do
        current_path.should eq(new_story_path)
        content = Faker::Lorem.paragraph
        fill_in "عنوان", with: Faker::Lorem.characters(10)
        fill_in "محتوا", with: content
        click_button 'پیش‌نمایش'
        page.should have_selector 'blockquote', text: content
        page.should have_content 'هشدار'
      end
    end

    context "as a known user"
  end
end

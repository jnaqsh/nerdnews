# encoding: utf-8
require 'spec_helper'

describe "Stories" do

  it "raise the counter by one when visiting a page" do
    story = FactoryGirl.create(:story)
    expect {
      visit story_url story
      }.to change { story.reload.view_counter }.by(1)
  end

  describe "Post a Story" do
    context "as an unknown user" do
      
      before do 
        visit root_url
        click_link "جدید"
        current_path.should eq(new_story_path)
      end

      it 'posts the story and put it on queue' do
        fill_in "عنوان", with: Faker::Lorem.characters(10)
        fill_in "محتوا", with: Faker::Lorem.paragraph
        click_button "ایجاد"
        page.should have_content("موفقیت")
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

    context "as a known user"
  end
end

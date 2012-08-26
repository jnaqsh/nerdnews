# encoding: utf-8
require 'spec_helper'

describe "Stories" do
  describe "Post a Story" do
    context "as an unknown user" do
      it 'posts the story and put it on queue' do
        visit root_url
        click_link "جدید"
        current_path.should eq(new_story_path)
        fill_in "عنوان", with: Faker::Lorem.characters(10)
        fill_in "محتوا", with: Faker::Lorem.paragraph
        click_button "ایجاد"
        page.should have_content("موفقیت")
      end
    end

    context "as a known user"
  end
end

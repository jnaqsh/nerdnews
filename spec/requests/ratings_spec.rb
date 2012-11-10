# encoding: utf-8
require 'spec_helper'

describe "Ratings" do
  describe "GET /ratings" do
    it 'should add/edit a new rating' do
      user = FactoryGirl.create(:founder_user)
      login user
      visit ratings_path
      click_link 'جدید'
      current_path.should eq new_rating_path
      fill_in 'نام', with: 'جالب'
      fill_in 'وزن', with: '5'
      click_button 'ایجاد'
      current_path.should eq ratings_path
      page.should have_content 'موفقیت'
      click_link 'جالب'
      fill_in 'نام', with: 'قشنگ'
      click_button 'به‌روزرسانی'
      current_path.should eq ratings_path
      page.should have_content 'موفقیت'
    end
  end
end

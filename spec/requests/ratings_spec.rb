# encoding: utf-8
require 'spec_helper'

describe "Ratings" do
  describe "GET /ratings" do
    
    before do
      user = FactoryGirl.create(:founder_user)
      login user
    end

    it 'should add a new rating' do
      visit ratings_path
      click_link 'جدید'
      current_path.should eq new_rating_path
      fill_in 'نام', with: 'جالب'
      fill_in 'وزن', with: '5'
      choose 'خبرها'
      click_button 'ایجاد'
      current_path.should eq ratings_path
      page.should have_content 'موفقیت'
      page.should have_content 'جالب'
    end

    it 'should edit a rating' do
      rating = FactoryGirl.create(:rating)
      visit ratings_path
      click_link rating.name
      fill_in 'نام', with: 'قشنگ'
      click_button 'به‌روزرسانی'
      current_path.should eq ratings_path
      page.should have_content 'موفقیت'
      page.should have_content 'قشنگ'
    end

    it 'should destroy a rating' do
      rating = FactoryGirl.create(:rating)
      visit ratings_path
      click_link 'حذف'
      page.should have_content 'موفقیت'
      page.should_not have_content rating.name
    end
  end
end

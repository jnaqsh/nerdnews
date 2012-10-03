# encoding: utf-8
require 'spec_helper'

describe "Users" do
  context 'Rating' do

    before do
      @user = FactoryGirl.create(:user)
      login @user
      @story = FactoryGirl.create(:story, user: @user)
      visit story_path @story
    end
    
    context 'Users' do
      it 'should add a point after commenting/replaying' do
        expect {
          fill_in 'دیدگاه', with: 'comment'
          click_button 'ایجاد'
        }.to change { @user.reload.user_rate }.by(1)
        expect {
          click_on 'پاسخ'
          fill_in 'دیدگاه', with: 'comment'
          click_button 'ایجاد'
        }.to change { @user.reload.user_rate }.by(1)
      end
    end

    context 'Stories' do
      it 'should show the rating items for story', js: true do
        pos = FactoryGirl.create(:rating)
        neg = FactoryGirl.create(:negative_rating)
        visit story_path @story
        click_button 'btn-thumbs-up'
        page.should have_content pos.name
        click_button 'btn-thumbs-down'
        page.should have_content neg.name
      end

    end
  end
end
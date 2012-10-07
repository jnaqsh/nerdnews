# encoding: utf-8
require 'spec_helper'

describe '/Users' do
  context '/Rating' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      login @user
      @story = FactoryGirl.create(:story, user: @user)
      visit story_path @story
    end

    after(:each) do
      logout
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

    context 'Stories', js: true do
      
      before do
        @pos = FactoryGirl.create(:neg)
        @rating = FactoryGirl.create(:negative_rating)
      end 

      it 'shows the rating items for story' do
        visit story_path @story
        click_button 'btn-thumbs-up'
        page.should have_content @pos.name
        click_button 'btn-thumbs-down'
        page.should have_content @neg.name
      end

      it 'rates a story' do
        visit story_path @story
        click_button 'btn-thumbs-up'
        click_link @pos.name
        current_path.should eq stories_path
        page.should have_content 'موفقیت'
      end
    end
  end
end
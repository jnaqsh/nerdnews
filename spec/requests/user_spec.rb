# encoding: utf-8
require 'spec_helper'

describe '/Users' do
  context '/Rating' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @story = FactoryGirl.create(:story, user: @user)
    end

    # after(:each) do
    #   logout
    # end
    
    context 'Users' do
      before do 
        login @user
        visit story_path @story
      end

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
      
      before(:each) do
        @pos = FactoryGirl.create(:rating)
        @neg = FactoryGirl.create(:negative_rating)
        visit story_path @story
      end 

      it 'shows the rating items for story' do
        click_button 'btn-thumbs-up'
        page.should have_content @pos.name
        click_button 'btn-thumbs-down'
        page.should have_content @neg.name
      end

      it 'rates a story' do
        click_button 'btn-thumbs-up'
        click_link @pos.name
        current_path.should eq stories_path
        page.should have_content 'موفقیت'
      end

      it 'unknown user can\'t vote after voting for first time' do
        click_button 'btn-thumbs-up'
        click_link @pos.name
        visit story_path @story
        page.has_no_button? 'btn-thumbs-up'
      end

      it 'known user can\'t vote after voting for first time' do
        click_button 'btn-thumbs-up'
        click_link @pos.name
        visit story_path @story
        page.has_no_button? 'btn-thumbs-up'
      end
    end
  end
end
# encoding: utf-8
require 'spec_helper'

describe '/Users' do
  context '/Rating' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      @story = FactoryGirl.create(:story, user: @user)
    end
    
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

      it 'should add a point after posting a stroy' do
        visit new_story_path
        expect {
          fill_in 'عنوان', with: @story.title
          fill_in 'محتوا', with: @story.content
          click_button 'ایجاد'
        }.to change { @user.reload.user_rate }.by(1)
      end

      it 'should add a point after a story approved' do
        logout
        admin = FactoryGirl.create(:admin_user)
        login admin
        visit unpublished_stories_path
        expect {
          click_link 'انتشار'
        }.to change { @user.reload.user_rate }.by(3)
      end

      it 'should add a point after ranking a comment'
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

      it 'rates a story successfully' do
        click_button 'btn-thumbs-up'
        click_link @pos.name
        current_path.should eq stories_path
        page.should have_content 'موفقیت'
      end

      it 'gains a point after rating to a story' do
        login @user
        visit story_path @story
        click_button 'btn-thumbs-up'
        expect {
          click_link @pos.name
        }.to change { @user.reload.user_rate }.by(1)
      end

      it 'wont let unknown user to vote after voting for first time' do
        click_button 'btn-thumbs-up'
        click_link @pos.name
        visit story_path @story
        page.should have_no_button 'btn-thumbs-up'
      end

      it 'wont let known user to vote after voting for first time' do
        login @user
        visit story_path @story
        click_button 'btn-thumbs-up'
        click_link @pos.name
        visit story_path @story
        page.should have_no_button 'btn-thumbs-up'
      end
    end
  end
end
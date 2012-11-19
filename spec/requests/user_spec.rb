# encoding: utf-8
require 'spec_helper'

describe '/Users' do
  before { @user = FactoryGirl.create(:user) }
  context '/Profile' do
    it 'can edit his profile page' do
      login @user
      visit user_path(@user)
      click_link 'ویرایش پروفایل'
      fill_in 'ایمیل', with: 'arash@email.com'
      click_button 'تایید'
      @user.reload.email.should == 'arash@email.com'
    end

    it 'wont let users to edit others profiles' do
      user1 = FactoryGirl.create(:user)
      login user1
      visit user_path(@user)
      page.should have_no_button 'ویرایش پروفایل'
    end

    it 'can get users posts' do
      story = FactoryGirl.create(:approved_story, user: @user)
      story.user.should eq(@user)
      visit posts_user_path(@user)
      page.should have_content story.title
    end

    it 'can get users comments' do
      story = FactoryGirl.create(:approved_story, user: @user)
      comment = FactoryGirl.create(:comment, user: @user, story: story)
      visit comments_user_path(@user)
      page.should have_content comment.content[0..26] #because of truncate
    end

    it 'can get users favorites' do
      story = FactoryGirl.create(:approved_story, user: @user)
      rating = FactoryGirl.create(:rating)
      vote = FactoryGirl.create(:vote, story: story, user: @user, rating: rating)
      visit favorites_user_path(@user)
      page.should have_content vote.rating.name
    end
  end

  context '/MyPage' do
    it 'shows favorite tags in mypage' do
      story = FactoryGirl.create(:story)
      tag = FactoryGirl.create(:tag)
      story.tags << tag
      user = FactoryGirl.create(:user, favorite_tags: tag.name)
      login user
      visit mypage_index_path
      page.should have_content tag.name
    end

    it 'shows a notice if user doesnt have any favorite tags' do
      user = FactoryGirl.create(:user, favorite_tags: nil)
      login user
      visit mypage_index_path
      page.should have_content 'لطفا'
    end

    it 'shows a notice if no story found for favorite tags' do
      user = FactoryGirl.create(:user, favorite_tags: 'gnome')
      login user
      visit mypage_index_path
      page.should have_content 'موردی جهت نمایش پیدا نشد'
    end
  end

  context '/Rating' do

    before(:each) do
      @story = FactoryGirl.create(:approved_story, user: @user)
    end

    context 'Users' do
      before do
        login @user
        visit story_path @story
      end

      it 'should add a point after commenting/replaying' do
        expect {
          fill_in 'comment_content', with: 'comment'
          click_button 'ایجاد'
        }.to change { @user.reload.user_rate }.by(1)
        expect {
          click_on 'پاسخ'
          fill_in 'comment_content', with: 'comment'
          click_button 'ایجاد'
        }.to change { @user.reload.user_rate }.by(1)
      end

      it 'should add a point after posting a stroy' do
        visit new_story_path
        expect {
          fill_in 'story_title', with: @story.title
          fill_in 'story_content', with: @story.content
          fill_in 'story_spam_answer', with: "four"
          click_button 'ایجاد'
        }.to change { @user.reload.user_rate }.by(1)
      end

      it 'should add a point after a story approved' do
        @story = FactoryGirl.create(:story, user: @user)
        logout
        approved_user = FactoryGirl.create(:approved_user)
        login approved_user
        visit unpublished_stories_path
        expect {
          click_link 'انتشار'
        }.to change { @user.reload.user_rate }.by(3)
      end

      it 'should add a point after ranking a comment'
    end

    context 'Stories', js: true do

      before(:each) do
        login @user
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
        current_path.should eq story_path(@story)
        page.should have_content 'موفقیت'
      end

      it 'gains a point after rating to a story' do
        visit story_path @story
        click_button 'btn-thumbs-up'
        expect {
          click_link @pos.name
          sleep 1 # Seems that we have to wait a moment for data from Ajax
        }.to change { @user.reload.user_rate }.by(1)
      end

      it 'wont let unknown user to vote after voting for first time' do
        click_button 'btn-thumbs-up'
        click_link @pos.name
        visit story_path @story
        page.should have_no_button 'btn-thumbs-up'
      end

      it 'wont let known user to vote after voting for first time' do
        visit story_path @story
        click_button 'btn-thumbs-up'
        click_link @pos.name
        visit story_path @story
        page.should have_no_button 'btn-thumbs-up'
      end
    end
  end
end

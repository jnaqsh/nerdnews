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
      story = FactoryGirl.create(:approved_story, user_id: @user)
      visit posts_user_path(@user)
      page.should have_content story.title
    end

    it 'can get users comments' do
      story = FactoryGirl.create(:approved_story, user_id: @user)
      comment = FactoryGirl.create(:comment, user_id: @user, story_id: story)
      visit comments_user_path(@user)
      page.should have_content comment.content[0..26] #because of truncate
    end

    it 'can get users favorites' do
      story = FactoryGirl.create(:approved_story, user_id: @user)
      rating = FactoryGirl.create(:rating)
      vote = FactoryGirl.create(:vote, story_id: story, user_id: @user, rating_id: rating)
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
      page.should have_content 'لطفا تعدادی تگ موردعلاقه به پروفایل خود اضافه کنید'
    end

    it 'shows a notice if no story found for favorite tags' do
      user = FactoryGirl.create(:user, favorite_tags: 'gnome')
      login user
      visit mypage_index_path
      page.should have_content 'موردی جهت نمایش پیدا نشد'
    end
  end

  context '/Message' do
    it 'creates new message' do
      login @user
      visit new_user_message_path(@user)
      fill_in 'message_reciver_id', with: @user.id
      fill_in 'message_subject', with: 'subject'
      fill_in 'message_message', with: 'new message from a honest test :)'
      click_button 'ایجاد'
      page.should have_content 'موفقیت'
    end

    it 'shows related notices if there\'s no message available' do
      login @user
      visit user_messages_path(@user)
      page.should have_content 'تاکنون پیامی دریافت نکرده‌اید'
      visit sent_user_messages_path(@user)
      page.should have_content 'تاکنون پیامی برای کاربران ارسال نکرده‌اید'
    end

    context do
      before do
        @sender = FactoryGirl.create(:user)
        @message = FactoryGirl.create(:message, user_id: @sender.id, reciver_id: @user.id)
      end
      it 'shows recived messages (index page) and mark it as read' do
        login @user
        visit user_messages_path(@user)
        page.should have_content @message.subject
        expect {
          click_link @message.subject
        }.to change{ @message.reload.unread? }.to(false)
      end

      it 'shows sent messages' do
        login @sender
        visit sent_user_messages_path(@sender)
        page.should have_content @message.subject
      end

      it 'removes one of the recived messages' do
        pending 'How? if reciver removes one of the messages, it\'ll be removed for sender too'
      end

      it 'wont let others to view messages' do
        other_user = FactoryGirl.create(:user)
        login other_user
        visit user_message_path(@sender, @message)
        current_path.should eq(root_path)
      end
    end
  end

  context '/Rating' do

    before(:each) do
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
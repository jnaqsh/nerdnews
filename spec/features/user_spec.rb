# encoding: utf-8
require 'spec_helper'

describe '/Users' do
  before { @user = FactoryGirl.create(:user) }
  context "sign up" do
    it 'should a user signs up successfully and send an sign up confirmation email' do
      visit new_user_path
      fill_in 'user_full_name', with: "a validate full_name"
      fill_in 'user_email', with: 'user@example.com'
      click_button I18n.t('users.signup_form.submit')
      page.should have_content(I18n.t('controllers.users.create.flash.success'))
    end

    it 'should logouts successfully' do
      login @user
      click_link 'خروج'
      current_path.should eq(root_path)
      page.should have_content(I18n.t('controllers.sessions.destroy.flash.success'))
    end
  end

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
      vote = FactoryGirl.create(:vote, voteable: story, user: @user, rating: rating)
      visit favorites_user_path(@user)
      page.should have_content vote.rating.name
    end

    it 'can get users activity logs' do
      login @user
      visit activity_logs_user_path(@user)
      page.should have_content "وارد نردنیوز شد"
    end

    it "doesnt show email if email_visibility is flase" do
      user = FactoryGirl.create(:user, email_visibility: false)
      visit users_path(user)
      page.should_not have_content user.email
    end
  end

  context '/MyPage', search: true do
    it 'shows favorite tags in mypage' do
      pending "I don't know why it doesn't work, I think sunspot is problem"
      story = FactoryGirl.create(:story)
      tag = FactoryGirl.create(:tag)
      story.tags << tag
      user = FactoryGirl.create(:user, favorite_tags: tag.name)
      login user
      Sunspot.commit
      visit mypage_index_path
      page.should have_content tag.name
    end

    it 'shows a notice if user doesnt have any favorite tags' do
      user = FactoryGirl.create(:user, favorite_tags: nil)
      login user
      Sunspot.commit
      visit mypage_index_path
      page.should have_content 'لطفا'
    end

    it 'shows a notice if no story found for favorite tags' do
      pending "I don't know why it doesn't work, I think sunspot is problem"
      user = FactoryGirl.create(:user, favorite_tags: 'gnome')
      login user
      Sunspot.commit
      visit mypage_index_path
      page.should have_content 'موردی جهت نمایش پیدا نشد'
    end
  end

  context "/favoriteTag" do
    it "adds a tag to user favorites" do
      login @user
      story = FactoryGirl.create(:approved_story, user: @user)
      tag = FactoryGirl.create(:tag)
      story.tags << tag
      visit story_path(story)
      click_link "1"
      @user.reload.favored_tags.to_a.should be_include(tag.name)
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
        # Set user ip, user agent and referer for Capybara
        page.driver.options[:headers] = {'REMOTE_ADDR' => '1.2.3.4', 'HTTP_USER_AGENT' => 'Mozilla', 'HTTP_REFERER' => 'http://localhost'}
        # Stub request to akismet
        stub_akismet_connection

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

      it 'should not add a point after posting a stroy' do
        visit new_story_path
        expect {
          fill_in 'story_title', with: @story.title
          fill_in 'story_content', with: @story.content
          click_button 'ایجاد'
        }.to change { @user.reload.user_rate }.by(0)
      end

      it 'should add 3 points after posting a stroy and published' do
        @approved_user = FactoryGirl.create(:approved_user)
        visit new_story_path
        expect {
          fill_in 'story_title', with: @story.title
          fill_in 'story_content', with: @story.content
          click_button 'ایجاد'
          logout
          login @approved_user
          visit unpublished_stories_path
          click_link "انتشار"
        }.to change { @user.reload.user_rate }.by(3)
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
    end

    context '/Stories', js: true do

      before(:each) do
        login @user
        @pos = FactoryGirl.create(:rating)
        @neg = FactoryGirl.create(:negative_rating)
        visit story_path @story
      end

      it 'shows the rating items for story' do
        find('button.btn-thumbs-up').click
        find("div.thumbs-up-list").should be_visible
        page.should_not have_css('div.thumbs-down-list')

        find('button.btn-thumbs-down').click
        find("div.thumbs-down-list").should be_visible
        page.should_not have_css('div.thumbs-up-list')
      end

      it 'rates a story successfully' do
        find('button.btn-thumbs-up').click
        click_link @pos.name
        current_path.should eq story_path(@story)
        page.should have_content 'موفقیت'
        page.should have_selector('span.btn.btn-success.disabled')
      end

      it 'gains a point after rating to a story' do
        visit story_path @story
        find('button.btn-thumbs-up').click
        expect {
          click_link @pos.name
          sleep 1 # Seems that we have to wait a moment for data from Ajax
        }.to change { @user.reload.user_rate }.by(1)
      end

      it 'wont let unknown user to vote after voting for first time' do
        pending 'Unknown users can\'t vote at all, delete?'
        find('button.btn-thumbs-up').click
        click_link @pos.name
        visit story_path @story
        page.should have_no_button 'btn-thumbs-up'
      end

      it 'wont let known user to vote after voting for first time' do
        page.should have_selector 'button.btn-thumbs-up'
        find('button.btn-thumbs-up').click
        click_link @pos.name
        visit story_path @story
        page.should_not have_selector 'button.btn-thumbs-up'
      end

      it 'should toggle list of voters' do
        page.should have_selector 'button.btn-thumbs-up'
        find('button.btn-thumbs-up').click
        click_link @pos.name
        visit story_path @story
        click_link I18n.t('stories.story.voters')
        within("div.voters") {page.should have_content @user.full_name}
        click_link I18n.t('stories.story.voters')
        page.should_not have_selector("div.voters", visible: true)
      end
    end
  end
end

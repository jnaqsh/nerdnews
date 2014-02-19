# encoding: utf-8
require 'spec_helper'

describe "Comments" do
  let(:user)  { FactoryGirl.create :user }
  let(:founder_user) { FactoryGirl.create :founder_user }
  let(:story) { FactoryGirl.create :approved_story }

  describe "/sending comment" do
    before do
      # Stub request to akismet
      stub_akismet_connection
    end

    context '/Unknown user' do
      it "sends and reply to a comment" do
        visit new_story_comment_path story.id
        fill_in "comment_name", with: user.full_name
        fill_in "comment_email", with: user.email
        fill_in "comment_website", with: user.website
        fill_in "comment_content", with: Faker::Lorem.paragraph
        fill_in "comment_spam_answer", with: "four"
        click_button "ایجاد"
        page.should have_content "موفقیت"

        current_path.should eq(story_path story)
        click_link "پاسخ"
        fill_in "comment_name", with: user.full_name
        fill_in "comment_email", with: user.email
        fill_in "comment_website", with: user.website
        fill_in "comment_content", with: Faker::Lorem.paragraph
        fill_in "comment_spam_answer", with: "four"
        click_button "ایجاد"
        page.should have_content("موفقیت")
      end
    end

    context '/Known user' do
      before do
        login user
      end

      it "sends and reply to a comment" do
        visit new_story_comment_path story.id
        fill_in "comment_content", with: Faker::Lorem.paragraph
        click_button "ایجاد"
        page.should have_content "موفقیت"

        current_path.should eq(story_path story)
        click_link "پاسخ"
        fill_in "comment_content", with: Faker::Lorem.paragraph
        click_button "ایجاد"
        page.should have_content("موفقیت")
      end

    end

    context '/Sending mail' do
      it "Sends email to original author when replies" do
        comment = FactoryGirl.create :comment, story_id: story.id, user_id: user.id
        visit story_path story
        click_link "پاسخ"
        fill_in "comment_name", with: user.full_name
        fill_in "comment_email", with: user.email
        fill_in "comment_content", with: Faker::Lorem.paragraph
        fill_in "comment_spam_answer", with: "four"
        click_button 'ایجاد'
        last_email.to.should include(comment.email)
      end
    end

  end

  context '/Rating', js: true do
    let!(:comment) { FactoryGirl.create :comment, story_id: story.id }
    let!(:pos) { FactoryGirl.create :rating_comments }

    before do
      login user
      visit story_path story
    end

    it 'shows the rating items for comment' do
      find('button.btn-comments-thumbs-up').click
      find("div.thumbs-up-list").should be_visible
      page.should_not have_css('div.thumbs-down-list')

      find('button.btn-comments-thumbs-down').click
      page.should_not have_css('div.thumbs-up-list')
      find("div.thumbs-down-list").should be_visible
    end

    it 'rates a comment successfully' do
      find('button.btn-comments-thumbs-up').click
      click_link pos.name
      current_path.should eq story_path(story)
      page.should have_content 'موفقیت'
      page.should have_selector('span.btn.btn-success.disabled')
    end

    it 'gains a point after rating to a comment' do
      visit story_path story
      find('button.btn-comments-thumbs-up').click
      expect {
        click_link pos.name
        sleep 1
      }.to change { user.reload.user_rate }.by(1)
    end

    it 'wont let known user to vote after voting for first time' do
      visit story_path story
      find('button.btn-comments-thumbs-up').click
      click_link pos.name
      sleep 1
      visit story_path story
      page.should_not have_selector 'button.btn-comments-thumbs-up'
    end
  end

  context '#destroy_spams' do
    before do
      login founder_user
    end

    it 'destroys all spam' do
      FactoryGirl.create_list :comment, 10, story_id: story.id, name: 'viagra-test-123'
      expect(Comment.unapproved.size).to eq(10)
      visit comments_path
      click_link 'destroy_spams'
      page.should have_content 'موفقیت'
      expect(Comment.unapproved.size).to eq(0)
    end
  end
end

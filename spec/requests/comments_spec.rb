# encoding: utf-8
require 'spec_helper'

describe "Comments" do
  let(:user)  { FactoryGirl.create :user }
  let(:story) { FactoryGirl.create :approved_story }
  
  before do
    # Set user ip, user agent and referer for Capybara
    page.driver.options[:headers] = {'REMOTE_ADDR' => '1.2.3.4', 'HTTP_USER_AGENT' => 'Mozilla', 'HTTP_REFERER' => 'http://localhost'}
  end

  it "sends and reply to a comment" do
    visit new_story_comment_path story.id
    fill_in "comment_name", with: user.full_name
    fill_in "comment_email", with: user.email
    fill_in "comment_website", with: user.website
    fill_in "comment_content", with: Faker::Lorem.paragraph
    click_button "ایجاد"
    page.should have_content "موفقیت"
    current_path.should eq(story_path story)
    click_link "پاسخ"
    fill_in "comment_name", with: user.full_name
    fill_in "comment_email", with: user.email
    fill_in "comment_website", with: user.website
    fill_in "comment_content", with: Faker::Lorem.paragraph
    click_button "ایجاد"
    page.should have_content("موفقیت")
  end

  it "Sends email to original author when replies" do
    comment = FactoryGirl.create :comment, story_id: story.id, user_id: user.id
    visit story_path story
    click_link "پاسخ"
    fill_in "comment_name", with: user.full_name
    fill_in "comment_email", with: user.email
    fill_in "comment_content", with: Faker::Lorem.paragraph
    click_button 'ایجاد'
    last_email.to.should include(comment.email)
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
      find("div.thumbs-down-list").should_not be_visible

      find('button.btn-comments-thumbs-down').click
      find("div.thumbs-up-list").should_not be_visible
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
        sleep 1 # Seems that we have to wait a moment for data from Ajax
      }.to change { user.reload.user_rate }.by(1)
    end

    it 'wont let known user to vote after voting for first time' do
      visit story_path story
      find('button.btn-comments-thumbs-up').click
      click_link pos.name
      visit story_path story
      page.should_not have_selector 'button.btn-comments-thumbs-up'
    end
  end
end

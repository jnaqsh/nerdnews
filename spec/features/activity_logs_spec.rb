# encoding: utf-8
require 'spec_helper'

describe "activity logs", solr: true do
  it "should a new or approved user gets latest activity logs" do
    user = FactoryGirl.create(:approved_user)
    create_story user
    Sunspot.commit

    click_link "user-menu"
    click_link "آخرین تغییرات"
    current_path.should eq(activity_logs_path)
    page.should have_content "ایجاد"
    page.should_not have_content "وارد نردنیوز شد"
    page.should_not have_content "نمایش"
  end

  it "should a founder user gets latest activity logs and view it" do
    user = FactoryGirl.create(:founder_user)

    create_story user
    Sunspot.commit
    click_link "user-menu"
    click_link "آخرین تغییرات"
    current_path.should eq(activity_logs_path)
    page.should have_content "وارد"
    page.should have_content "نمایش"
  end

  it "should not spam comments appears on activiy logs" do
    # Stub request to akismet
    stub_akismet_connection_for_spam
    user = FactoryGirl.create(:user)
    story = FactoryGirl.create :approved_story
    FactoryGirl.create :comment, story_id: story.id, name: 'viagra-test-123'

    login user

    visit root_path
    click_link "user-menu"
    click_link "آخرین تغییرات"
    page.should_not have_content story.title.truncate(40)
    page.should_not have_content "شخص ناشناس"
  end
end

# encoding: utf-8
require 'spec_helper'

describe "activity logs", search: true do
  it "should a new or approved user gets latest activity logs" do
    user = FactoryGirl.create(:approved_user)

    create_story user
    Sunspot.commit
    click_link "user-menu"
    click_link "آخرین تغییرات"
    current_path.should eq(activity_logs_path)
    page.should have_content "ایجاد"
    page.should_not have_content "وارد نردنیوز شدید"
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
end

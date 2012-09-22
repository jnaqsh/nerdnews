# encoding: UTF-8
require 'spec_helper'

describe "Tags" do
  describe "GET /tags" do
    it "should make a new tag" do
      visit tags_url
      click_on "جدید"
      current_path.should eq(new_tag_path)
      fill_in 'نام', with: "tag"
      click_button "ایجاد"
    end
  end
end

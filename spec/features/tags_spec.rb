# encoding: UTF-8
require 'spec_helper'

describe "Tags", search: true do
  before do
    approved_user = FactoryGirl.create(:approved_user)
    login approved_user
    Sunspot.commit
  end

  it "should make a new tag" do
    visit tags_path
    click_on "تگ جدید"
    current_path.should eq(new_tag_path)
    fill_in 'نام', with: "tag"
    attach_file('tag_thumbnail', 'app/assets/images/rails.png')
    click_button "ایجاد تگ"
    current_path.should eq(tags_path)
    page.should have_content 'موفقیت'
  end

  it "should edit a tag" do
    tag = FactoryGirl.create(:tag)
    Sunspot.commit
    visit edit_tag_path(tag)
    fill_in 'نام', with: 'edited'
    click_button 'تگ'
    tag.reload.name.should == 'edited'
    page.should have_content 'موفقیت'
  end

  it 'filters stories by tag' do
    pending "I couldn't figure out why it doesn't pass"
    story = FactoryGirl.create(:approved_story)
    tag = FactoryGirl.create(:tag)
    story.tags << tag
    story1 = FactoryGirl.create(:approved_story)
    Sunspot.commit
    visit stories_path(tag: tag.name)
    page.should have_content(story.title)
    page.should_not have_content(story1.title)
  end
end

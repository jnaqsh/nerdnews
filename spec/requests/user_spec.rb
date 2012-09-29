# encoding: utf-8
require 'spec_helper'

describe "Users" do
  context 'Rating' do
    it 'should add a point after commenting/replaying' do
      user = FactoryGirl.create(:user)
      login user
      story = FactoryGirl.create(:story, user: user)
      visit story_path story
      expect {
        fill_in 'دیدگاه', with: 'comment'
        click_button 'ایجاد'
      }.to change { user.reload.user_rate }.by(1)
      expect {
        click_on 'پاسخ'
        fill_in 'دیدگاه', with: 'comment'
        click_button 'ایجاد'
      }.to change { user.reload.user_rate }.by(1)
    end
  end
end
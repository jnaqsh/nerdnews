#encoding: utf-8

require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = FactoryGirl.create(:user)
    visit new_session_path
    click_link "گذرواژه"
    fill_in "email", :with => user.email
    click_button "بازنشانی گذرواژه"
    current_path.should eq(root_path)
    page.should have_content(I18n.t('controllers.password_resets.create.flash.success'))
    last_email.to.should include(user.email)
  end

  it "does not email invalid user when requesting password reset" do
    visit new_session_path
    click_link "گذرواژه"
    fill_in "email", :with => "nobody@example.com"
    click_button "بازنشانی گذرواژه"
    current_path.should eq(root_path)
    page.should have_content(I18n.t('controllers.password_resets.create.flash.success'))
    last_email.should be_nil
  end

  it "updates the user password when confirmation matches" do
    user = FactoryGirl.create(:user, :password_reset_token => "something", :password_reset_sent_at => 1.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "user_password", :with => "foobar"
    click_button "بازنشانی گذرواژه"
    page.should have_content("نمی‌خواند")
    fill_in "user_password", :with => "foobar"
    fill_in "user_password_confirmation", :with => "foobar"
    click_button "بازنشانی گذرواژه"
    page.should have_content(I18n.t('controllers.password_resets.update.flash.success'))
  end

  it "reports when password token has expired" do
    user = FactoryGirl.create(:user, :password_reset_token => "something", :password_reset_sent_at => 5.hour.ago)
    visit edit_password_reset_path(user.password_reset_token)
    fill_in "user_password", :with => "foobar"
    fill_in "user_password_confirmation", :with => "foobar"
    click_button "بازنشانی گذرواژه"
    page.should have_content(I18n.t ('controllers.password_resets.update.flash.fail'))
  end

  it "raises record not found when password token is invalid" do
    lambda {
      visit edit_password_reset_path("invalid")
    }.should raise_exception(ActiveRecord::RecordNotFound)
  end
end

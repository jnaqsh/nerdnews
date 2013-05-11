# encoding: utf-8
require 'spec_helper'

describe "Omniauths" do
  context 'OpenId' do
    context 'known user' do
      before do
        @user = FactoryGirl.create(:user)
        login @user
        visit identities_path
        click_on 'MYOPENID'
      end

      it 'Adds/Removes a MyOpenID identity' do
        current_path.should eq(identities_path)
        page.should have_content('موفقیت')
        page.should have_content('حذف این حساب')
        click_link 'حذف'
        page.should have_content('موفقیت')
      end

      it 'raises error if account already exist' do
        click_on 'MYOPENID'
        page.should have_content('قبلا در سایت ثبت شده است')
      end
    end

    context 'Unknown user' do
      before do
        OmniAuth.config.add_mock :myopenid, uid: "12345", info: { name: "Arash Joon", email: 'ArashJJ@jmail.com' }
        visit new_session_path
        click_link 'MYOPENID'
      end

      it 'creates account with openid' do
        current_path.should eq(new_user_path)
        page.should have_content 'حساب OpenID شما ثبت شده است'
        page.should have_content 'myopenid'
        page.should have_content '1234'
        page.should have_content 'Arash Joon'
        page.should have_content 'ArashJJ@jmail.com'
        click_button 'تایید'
        page.should have_content 'موفقیت'
      end

      it 'signes in user if identity exist' do
        current_path.should eq(new_user_path)
        click_button 'تایید'
        current_path.should eq(user_path(Identity.last.user))
        click_link 'خروج' # signe out before testing again
        current_path.should eq(root_path)
        page.should have_content(I18n.t("controllers.sessions.destroy.flash.success"))
        visit new_session_path
        current_path.should eq(new_session_path)
        click_link 'MYOPENID'
        page.should have_content('با موفقیت وارد شدید')
      end

      it 'cancels creating new account' do
        click_button 'لغو'
        page.should have_content('ایجاد حساب لغو شد')
      end

      it 'doesnt let visit identities page' do
        visit identities_path
        current_path.should eq(root_path)
        page.should have_content(I18n.t("unauthorized.manage.all"))
      end
    end

    context 'Error' do
      before do
        OmniAuth.config.mock_auth[:myopenid] = :invalid_credentials
      end

      it 'raises error if there is an error with provider' do
        visit new_session_path
        click_link 'MYOPENID'
        page.should have_content('خطایی در سرویس‌دهنده رخ داد')
      end
    end
  end
end

#encoding: utf-8

require 'spec_helper'

describe "Messages" do
  before do
    @sender = FactoryGirl.create(:user)
    @receiver = FactoryGirl.create(:user)
  end

  it 'should creates a new message' do
    login @sender
    visit user_path(@receiver)
    current_path.should eq(user_path(@receiver))
    click_link I18n.t('layouts.user_profile.send_message')
    fill_in 'message_subject', with: 'subject'
    fill_in 'message_message', with: 'new message from a honest test :)'
    click_button 'ایجاد'
    current_path.should eq(user_messages_path(@sender))
    page.should have_content @sender.sent_messages.first.subject
    page.should have_content 'موفقیت'
  end

  it 'should shows no messages notice' do
    login @sender
    visit user_messages_path(@sender)
    page.should have_content I18n.t("messages.index.no_messages")
  end

  context do
    before do
      @message = FactoryGirl.create(:message, sender: @sender, receiver: @receiver)
    end

    it 'should shows recived messages and mark it as read' do
      login @receiver
      expect {
        visit user_messages_path(@receiver)
      }.to change{ @message.reload.unread? }.to(false)
    end

    it 'should receiver removes one of the recived messages' do
      login @receiver
      visit user_messages_path(@receiver)
      page.should have_content(I18n.t('helpers.links.destroy'))
      click_link I18n.t('helpers.links.destroy')
      page.should have_content(I18n.t('messages.index.no_messages'))
    end

    it "should not sender removes sent messages" do
      login @sender
      visit user_messages_path(@sender)
      page.should_not have_content I18n.t('helpers.links.destroy')
    end

    it 'wont let others to view messages' do
      other_user = FactoryGirl.create(:user)
      login other_user
      visit user_messages_path(@sender)
      current_path.should eq(root_path)
    end
  end
end

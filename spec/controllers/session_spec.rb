# encoding: utf-8
require 'spec_helper'

describe SessionsController do
  before(:each) do
    @user = FactoryGirl.create(:user, email: 'something@something.com')
  end

  context 'POST /create' do
    it 'should authenticate, assign flash notice and assign session[:user_id]' do
      post :create, email: 'something@something.com', password: 'secret'
      # session[:user_id].should eq(@user.id)
      cookies.signed[:user_id].should eq(@user.id)
      flash[:notice].should eq(I18n.t('controllers.sessions.create.flash.success'))
    end


    it "should assign flash error and set session[:user_id] to nil upon incorrect login" do
      post :create, email: 'something@something.com', password: 'somethingelse'
      session[:user_id].should be_nil
      flash[:error].should eq(I18n.t('controllers.sessions.create.flash.error'))
    end
  end

  context 'GET /destroy' do
    it "should reset session[:user_id] and assign a flash notice" do
      cookies.signed[:user_id] = 1
      get :destroy
      response.code.should eq("302")
      flash[:notice].should eq(I18n.t('controllers.sessions.destroy.flash.success'))
      cookies.signed[:user_id].should be_nil
    end
  end
end

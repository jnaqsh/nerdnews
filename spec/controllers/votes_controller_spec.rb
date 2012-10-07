# encoding: utf-8
require 'spec_helper'

describe VotesController do

  describe "POST /create" do
    before do
      @user = FactoryGirl.create(:user)
      @story = FactoryGirl.create(:story)
      @rating = FactoryGirl.create(:rating)
    end
    it 'should create a story rating' do
      post :create, user_id: @user, story_id: @story, rating_id: @rating
      flash[:notice].should eq('با موفقیت ثبت شد')
    end
  end
end

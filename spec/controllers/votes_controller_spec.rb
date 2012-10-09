# encoding: utf-8
require 'spec_helper'

describe VotesController do

  describe "POST /create" do
    before do
      @user = FactoryGirl.create(:user)
      @story = FactoryGirl.create(:story)
      @rating = FactoryGirl.create(:rating)
      @negative_rating = FactoryGirl.create(:negative_rating)
    end

    it 'should create a vote' do
      post :create, user_id: @user, story_id: @story, rating_id: @rating
      flash[:notice].should eq('با موفقیت ثبت شد')
    end

    context '/count' do
      it 'increases Storys positive count' do
        expect {
          post :create, user_id: @user, story_id: @story, rating_id: @rating, positive: true
        }.to change { @story.reload.positive_votes_count }.by(1)
      end

      it 'increases Storys negative count' do
        expect {
          post :create, user_id: @user, story_id: @story, rating_id: @negative_rating
        }.to change { @story.reload.negative_votes_count }.by(1)
      end
    end

    context '/set cookie' do
      before do 
        post :create, user_id: @user, story_id: @story, rating_id: @negative_rating 
      end

      it 'should create a cookie when an unknown user votes' do
        cookies[:votes].should == [@story.id].to_yaml
      end

      it 'shouldnt make two keys in cookie for same story' do
        post :create, user_id: @user, story_id: @story, rating_id: @negative_rating
        cookies[:votes].should == [@story.id].to_yaml
      end
    end
  end
end

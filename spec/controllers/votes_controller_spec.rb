# encoding: utf-8
require 'spec_helper'

describe VotesController do

  describe "POST /create" do
    before do
      @user = FactoryGirl.create(:user)
      @story = FactoryGirl.create(:story)
      @rating = FactoryGirl.create(:rating)
      @negative_rating = FactoryGirl.create(:negative_rating)
      cookies.signed[:user_id] = @user.id
    end

    it 'should all users create a vote' do
      post :create, story_id: @story, rating_id: @rating
      flash[:notice].should eq(I18n.t('controllers.votes.create.flash.success'))
    end

    it 'should not users create a vote with wrong story id or rating id' do
      post :create, story_id: "wrong_id", rating_id: @rating
      flash[:notice].should be_nil
      flash[:error].should eq(I18n.t('controllers.votes.create.flash.error'))
      post :create, story_id: @story.id, rating_id: "wrong_id"
      flash[:notice].should be_nil
      flash[:error].should eq(I18n.t('controllers.votes.create.flash.error'))
    end

    context '/count' do
      it 'increases Storys positive count' do
        expect {
          post :create, story_id: @story.id, rating_id: @rating, positive: true
        }.to change { @story.reload.positive_votes_count }.by(1)
      end

      it 'increases Storys negative count' do
        expect {
          post :create, story_id: @story.id, rating_id: @negative_rating
        }.to change { @story.reload.negative_votes_count }.by(1)
      end
    end
  end
end

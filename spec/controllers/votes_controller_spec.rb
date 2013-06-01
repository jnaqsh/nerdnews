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

    it 'lets all users to create vote' do
      post :create, story_id: @story, rating_id: @rating, voteable: "stories"
      assigns[:voteable].should eq(@story)
      flash[:notice].should eq(I18n.t('controllers.votes.create.flash.success'))
    end

    it 'should not users create a vote with wrong story id or rating id' do
      post :create, story_id: "wrong_id", rating_id: @rating, voteable: "stories"
      flash[:notice].should be_nil
      flash[:error].should eq(I18n.t('controllers.votes.create.flash.error'))
      post :create, story_id: @story.id, rating_id: "wrong_id", voteable: "stories"
      flash[:notice].should be_nil
      flash[:error].should eq(I18n.t('controllers.votes.create.flash.error'))
    end

    context '/count' do
      it 'increases Stories positive count' do
        expect {
          post :create, story_id: @story.id, rating_id: @rating, positive: true, voteable: "stories"
        }.to change { @story.reload.positive_votes_count }.by(1)
      end

      it 'increases Stories negative count' do
        expect {
          post :create, story_id: @story.id, rating_id: @negative_rating, voteable: "stories"
        }.to change { @story.reload.negative_votes_count }.by(1)
      end

      it 'increases Stories total point' do
        rating2 = FactoryGirl.create(:rating, weight: -3)
        user2 = FactoryGirl.create(:user)
        expect {
          post :create, story_id: @story.id, rating_id: @rating, positive: true, voteable: "stories"
          cookies.signed[:user_id] = user2.id # Another user logged in, a user cannot vote twice
          post :create, story_id: @story.id, rating_id: rating2, voteable: "stories"
        }.to change { @story.reload.total_point }.by(-2)
      end

    end
  end
end

class VotesController < ApplicationController
  load_and_authorize_resource

  def create
    begin
      @story = Story.find(params[:story_id])
      @rating = Rating.find(params[:rating_id])
      @user = current_user
      @vote = Vote.new()
      @vote.rating = @rating
      @vote.story = @story
      @vote.user = @user
    rescue ActiveRecord::RecordNotFound
      redirect_to stories_path, flash:{error: t('controllers.votes.create.flash.error')}
      return
    end

    type = params[:positive].present? and params[:positive] == true

    respond_to do |format|
      if @vote.save
        increment_story_votes_count(@story, type)
        rate_user(1,
          "#{current_user.full_name} voted a story with id #{@vote.story.id} and rate id of #{@vote.rating.id}")
        format.html { redirect_to story_path(@story), notice: t('controllers.votes.create.flash.success') }
      else
        format.html { redirect_to story_path(@story), flash:{error: t('controllers.votes.create.flash.error')} }
      end
    end
  end

  private
  def increment_story_votes_count(story, type = nil)
    if type
      story.increment! :positive_votes_count
    else
      story.increment! :negative_votes_count
    end
  end
end

class VotesController < ApplicationController
  load_and_authorize_resource

  def create
    begin
      @voteable = get_voteable
      @rating = Rating.find(params[:rating_id])
      @user = current_user
      @vote = Vote.new()
      @vote.voteable = @voteable
      @vote.rating = @rating
      @vote.user = @user
    rescue ActiveRecord::RecordNotFound
      redirect_to stories_path, flash:{error: t('controllers.votes.create.flash.error')}
      return
    end

    type = params[:positive].present? and params[:positive] == true

    respond_to do |format|
      if @vote.save
        increment_votes_count(@voteable, type)
        rate_user 1,
          "#{current_user.full_name} voted a story with id #{@vote.voteable.id} and rate id of #{@vote.rating.id}"
        format.html { redirect_to story_path(@voteable), notice: t('controllers.votes.create.flash.success') }
        format.js
      else
        format.html { redirect_to story_path(@voteable), flash:{error: t('controllers.votes.create.flash.error')} }
      end
    end
  end

private
  # TODO: Move this method to somewhere else
  def increment_votes_count(voteable, type = nil)
    if type
      voteable.increment! :positive_votes_count
    else
      voteable.increment! :negative_votes_count
    end
  end

  def get_voteable
    @voteable = params[:voteable].classify.constantize.find(voteable_id)
  end

  def voteable_id
    params[(params[:voteable].singularize + "_id").to_sym]
  end
end

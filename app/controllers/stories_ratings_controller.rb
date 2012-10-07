class StoriesRatingsController < ApplicationController
  def create
    @story_rating = StoriesRating.new(
      story_id: params[:story_id], 
      user_id: params[:user_id], 
      rating_id: params[:rating_id])

    respond_to do |format|
      if @story_rating.save
        format.html { redirect_to stories_path, notice: t('controllers.stories_ratings.create.flash.success') }
      end
    end
  end
end

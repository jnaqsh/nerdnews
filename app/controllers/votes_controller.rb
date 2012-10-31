class VotesController < ApplicationController
  load_and_authorize_resource

  def create
    @story = Story.find(params[:story_id])
    @rating = Rating.find(params[:rating_id])
    @user = current_user || nil
    @vote = Vote.new()
    @vote.rating = @rating
    @vote.story = @story
    @vote.user = @user

    type = params[:positive].present?

    respond_to do |format|
      if @vote.save
        increment_story_votes_count(@story, type)
        create_votes_cookie(@story) unless current_user.present?
        rate_user(current_user, 1, "#{current_user.full_name} voted a story with id #{@vote.story.id} and rate id of #{@vote.rating.id}") if current_user.present?
        format.html { redirect_to story_path(@story), notice: t('controllers.votes.create.flash.success') }
      else
        format.html {redirect_to stories_path, flash:{error: t('controllers.votes.create.flash.error')} }
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

    def create_votes_cookie(story)
      cookies[:votes] ? story_list = YAML.load(cookies[:votes]) : story_list = []
      unless story_list.include? story.id
        story_list << story.id
        cookies[:votes] = story_list.to_yaml
      end
    end
end

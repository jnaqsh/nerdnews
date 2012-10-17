class VotesController < ApplicationController
  def create
    @vote = Vote.new(
      story_id: params[:story_id], 
      user_id: params[:user_id], 
      rating_id: params[:rating_id])

    type = params[:positive].present?

    respond_to do |format|
      if @vote.save
        increment_story_votes_count(params[:story_id], type)
        create_votes_cookie(params[:story_id]) unless current_user.present?
        rate_user(current_user, 1, "#{current_user.full_name} voted a story with id #{@vote.story.id} and rate id of #{@vote.rating.id}") if current_user.present?
        format.html { redirect_to stories_path, notice: t('controllers.votes.create.flash.success') }
      end
    end
  end

  private
    def increment_story_votes_count(story, type = nil)
      story = Story.find(story)
      if type
        story.increment! :positive_votes_count
      else
        story.increment! :negative_votes_count
      end
    end

    def create_votes_cookie(story)
      story = story.to_i
      cookies[:votes] ? story_list = YAML.load(cookies[:votes]) : story_list = []
      unless story_list.include? story
        story_list << story
        cookies[:votes] = story_list.to_yaml
      end
    end
end

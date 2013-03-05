#encoding: utf-8

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
        record_log(@vote)

        increment_votes_count(@voteable, type)
        calculate_total_point(@voteable, @vote)
        rate_user 1
        format.html { redirect_to story_path(@voteable), notice: t('controllers.votes.create.flash.success') }
        format.js
      else
        format.html { redirect_to story_path(@voteable), flash:{error: t('controllers.votes.create.flash.error')} }
      end
    end
  end

private
  def get_voteable
    @voteable = params[:voteable].classify.constantize.find(voteable_id)
  end

  def voteable_id
    params[(params[:voteable].singularize + "_id").to_sym]
  end

  # TODO: Move this method to somewhere else
  def increment_votes_count(voteable, type = nil)
    if type
      voteable.increment! :positive_votes_count
    else
      voteable.increment! :negative_votes_count
    end
  end

  # TODO: Move this method to somewhere else
  def calculate_total_point(voteable, vote)
    voteable.increment! :total_point, vote.rating.weight
  end

  def record_log(vote)
    comment = vote.voteable
    story = vote.voteable
    rating = vote.rating

    if vote.voteable_type == "Story"
      record_activity %Q(به
        #{view_context.link_to story.title.truncate(50), story_path(story)} امتیاز
        #{rating.name} را داد)
    elsif vote.voteable_type == "Comment"
      record_activity %Q(به
        دیدگاه #{view_context.link_to comment.content.truncate(50),
          story_path(comment.story, :anchor => "comment_#{comment.id}")} امتیاز
          #{rating.name} را داد)
    end
  end
end

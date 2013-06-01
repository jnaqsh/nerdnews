#encoding: utf-8

class VotesController < ApplicationController
  load_and_authorize_resource

  def create
    begin
      @rating         = Rating.find(params[:rating_id])
      @user           = current_user
      @vote           = Vote.new()
      voteable_helper = VoteableHelper.new(params, @vote)
      @voteable       = voteable_helper.voteable_object
      @vote.voteable  = @voteable
      @vote.rating    = @rating
      @vote.user      = @user
    rescue ActiveRecord::RecordNotFound
      redirect_to stories_path, flash:{error: t('controllers.votes.create.flash.error')}
      return
    end

    type = params[:positive].present? and params[:positive] == true

    respond_to do |format|
      if @vote.save
        record_log(@voteable, @vote)

        voteable_helper.increment_votes_count(type)
        voteable_helper.calculate_total_point
        rate_user 1
        format.html { redirect_to story_path(@voteable), notice: t('controllers.votes.create.flash.success') }
        format.js
      else
        format.html { redirect_to story_path(@voteable), flash:{error: t('controllers.votes.create.flash.error')} }
      end
    end
  end

private
  def record_log(voteable, vote)
    vote = vote.reload

    if voteable.class.name == "Story"
      record_activity %Q(به خبر #{view_context.link_to voteable.title.truncate(40), story_path(voteable)} امتیاز #{vote.rating.name} را داد)
    elsif voteable.class.name == "Comment"
      record_activity %Q(به دیدگاه #{view_context.link_to voteable.content.truncate(40), story_path(voteable.story, :anchor => "comment_#{voteable.id}")} امتیاز #{vote.rating.name} را داد)
    end
  end

end

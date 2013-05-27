# encoding: utf-8

# VoteableHelper is mostly used on VotesController
class VoteableHelper

  def initialize(params, vote)
    @voteable = params[:voteable]
    @voteable_id = params[(@voteable.singularize + "_id").to_sym]
    @vote = vote
  end
  
  def voteable_object
    @voteable.classify.constantize.find(@voteable_id)
  end
  
  def calculate_total_point
    voteable_object.increment! :total_point, @vote.rating.weight
  end

  def increment_votes_count(type = nil)
    if type
      voteable_object.increment! :positive_votes_count
    else
      voteable_object.increment! :negative_votes_count
    end
  end

end
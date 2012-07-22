class TagsController < ApplicationController
  def index
    
    @tag = Tag.find_by_name(params[:name])
    @stories = @tag.stories

    respond_to do |format| 
      format.html
    end
  end
end

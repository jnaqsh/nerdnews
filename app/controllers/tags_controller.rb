class TagsController < ApplicationController
  def index
    
    @tag = Tag.find_by_name(params[:name])
    @stories = @tag.stories.order(:created_at).page params[:page]

    respond_to do |format| 
      format.html
    end
  end
end

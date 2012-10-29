class MypageController < ApplicationController
  authorize_resource :class => false
  def index

    @favorite_tags = current_user.favorite_tags_array
    
    if @favorite_tags.blank?
      flash[:notice] = t('.controllers.mypage.flash.add_tags')
    else
      @stories = Story.joins(:tags).where('tags.name' => @favorite_tags).order('created_at desc').page params[:page]
      flash[:error] = t('.controllers.mypage.flash.nothing_found') if @stories.blank?
    end
  end
end

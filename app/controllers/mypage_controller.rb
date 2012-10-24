class MypageController < ApplicationController
  authorize_resource :class => false
  def index

    @favorite_tags = current_user.favorite_tags
    
    if @favorite_tags.blank?
      flash[:notice] = t('.controllers.mypage.flash.add_tags')
    else
      @stories = Story.joins(:tags).where('tags.name' => @favorite_tags.split(','))
      flash[:error] = t('.controllers.mypage.flash.nothing_found') if @stories.blank?
    end
  end
end
